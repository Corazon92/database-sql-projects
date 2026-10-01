BEGIN;

CREATE OR REPLACE FUNCTION admin_bdd.normalize_reference(value text)
RETURNS text
LANGUAGE sql
IMMUTABLE
STRICT
AS $$
    SELECT regexp_replace(
        translate(
            upper(value),
            'ÀÂÄÇÈÉÊËÎÏÔÖÙÛÜ',
            'AAACEEEEIIOOUUU'
        ),
        '[^A-Z0-9]+',
        '',
        'g'
    );
$$;

CREATE OR REPLACE FUNCTION admin_bdd.validate_recipe_total()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    total numeric(7, 2);
BEGIN
    total := NEW.aggregate_pct + NEW.water_pct
        + NEW.admixture_pct + NEW.cement_pct;

    IF total <> 100.00 THEN
        RAISE EXCEPTION 'Recipe percentages must total 100 (received %)', total;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS recipe_total_is_100 ON admin_bdd.recipe;
CREATE TRIGGER recipe_total_is_100
BEFORE INSERT OR UPDATE ON admin_bdd.recipe
FOR EACH ROW EXECUTE FUNCTION admin_bdd.validate_recipe_total();

CREATE OR REPLACE FUNCTION admin_bdd.assign_production_reference()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    customer_name text;
    recipe_name text;
BEGIN
    SELECT name INTO STRICT customer_name
    FROM admin_bdd.customer
    WHERE id = NEW.customer_id;

    SELECT name INTO STRICT recipe_name
    FROM admin_bdd.recipe
    WHERE id = NEW.recipe_id;

    NEW.produced_at := date_trunc('second', COALESCE(NEW.produced_at, CURRENT_TIMESTAMP));
    NEW.reference := concat_ws(
        '_',
        admin_bdd.normalize_reference(customer_name),
        admin_bdd.normalize_reference(recipe_name),
        NEW.id,
        to_char(NEW.produced_at, 'YYYYMMDD_HH24MISS')
    );

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS production_reference ON admin_bdd.production;
CREATE TRIGGER production_reference
BEFORE INSERT ON admin_bdd.production
FOR EACH ROW EXECUTE FUNCTION admin_bdd.assign_production_reference();

COMMIT;
