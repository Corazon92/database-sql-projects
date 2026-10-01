BEGIN;

CREATE OR REPLACE VIEW admin_bdd.customer_view AS
SELECT name AS customer_name, address, phone
FROM admin_bdd.customer;

CREATE OR REPLACE VIEW admin_bdd.recipe_view AS
SELECT
    name AS recipe_name,
    aggregate_pct,
    water_pct,
    cement_pct,
    admixture_pct
FROM admin_bdd.recipe;

CREATE OR REPLACE VIEW admin_bdd.production_view AS
SELECT
    production.reference,
    customer.name AS customer_name,
    recipe.name AS recipe_name,
    production.quantity,
    production.produced_at
FROM admin_bdd.production
JOIN admin_bdd.customer ON customer.id = production.customer_id
JOIN admin_bdd.recipe ON recipe.id = production.recipe_id;

-- Compatibility views retain the field names used by the archived PcVue script.
CREATE OR REPLACE VIEW admin_bdd.vue_client AS
SELECT
    customer_name AS nom_client,
    address AS adresse,
    phone AS telephone
FROM admin_bdd.customer_view;

CREATE OR REPLACE VIEW admin_bdd.vue_recette AS
SELECT
    recipe_name AS nom_recette,
    aggregate_pct AS qte_granulat,
    water_pct AS qte_eau,
    cement_pct AS qte_ciment,
    admixture_pct AS qte_adjuvant
FROM admin_bdd.recipe_view;

CREATE OR REPLACE VIEW admin_bdd.vue_production AS
SELECT
    reference,
    customer_name AS nom_client,
    recipe_name AS nom_recette,
    quantity AS quantite,
    produced_at AS horodatage
FROM admin_bdd.production_view;

CREATE OR REPLACE FUNCTION admin_bdd.insert_production_from_view()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    selected_customer_id integer;
    selected_recipe_id integer;
BEGIN
    SELECT id INTO selected_customer_id
    FROM admin_bdd.customer
    WHERE name = NEW.customer_name;

    IF selected_customer_id IS NULL THEN
        RAISE EXCEPTION 'Unknown customer: %', NEW.customer_name;
    END IF;

    SELECT id INTO selected_recipe_id
    FROM admin_bdd.recipe
    WHERE name = NEW.recipe_name;

    IF selected_recipe_id IS NULL THEN
        RAISE EXCEPTION 'Unknown recipe: %', NEW.recipe_name;
    END IF;

    INSERT INTO admin_bdd.production (recipe_id, customer_id, quantity, produced_at)
    VALUES (
        selected_recipe_id,
        selected_customer_id,
        NEW.quantity,
        COALESCE(NEW.produced_at, CURRENT_TIMESTAMP)
    );

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS production_view_insert ON admin_bdd.production_view;
CREATE TRIGGER production_view_insert
INSTEAD OF INSERT ON admin_bdd.production_view
FOR EACH ROW EXECUTE FUNCTION admin_bdd.insert_production_from_view();

CREATE OR REPLACE FUNCTION admin_bdd.insert_production_from_pcvue()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO admin_bdd.production_view (
        customer_name,
        recipe_name,
        quantity,
        produced_at
    )
    VALUES (
        NEW.nom_client,
        NEW.nom_recette,
        NEW.quantite,
        COALESCE(NEW.horodatage, CURRENT_TIMESTAMP)
    );

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS pcvue_production_insert ON admin_bdd.vue_production;
CREATE TRIGGER pcvue_production_insert
INSTEAD OF INSERT ON admin_bdd.vue_production
FOR EACH ROW EXECUTE FUNCTION admin_bdd.insert_production_from_pcvue();

COMMIT;
