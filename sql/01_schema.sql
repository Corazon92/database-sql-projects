BEGIN;

CREATE SCHEMA IF NOT EXISTS admin_bdd;

CREATE TABLE IF NOT EXISTS admin_bdd.recipe (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE,
    aggregate_pct numeric(5, 2) NOT NULL CHECK (aggregate_pct BETWEEN 0 AND 100),
    water_pct numeric(5, 2) NOT NULL CHECK (water_pct BETWEEN 0 AND 100),
    admixture_pct numeric(5, 2) NOT NULL CHECK (admixture_pct BETWEEN 0 AND 100),
    cement_pct numeric(5, 2) NOT NULL CHECK (cement_pct BETWEEN 0 AND 100)
);

CREATE TABLE IF NOT EXISTS admin_bdd.customer (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE,
    address text,
    phone text
);

CREATE TABLE IF NOT EXISTS admin_bdd.production (
    id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    reference text UNIQUE,
    recipe_id integer NOT NULL REFERENCES admin_bdd.recipe(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    customer_id integer NOT NULL REFERENCES admin_bdd.customer(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    quantity numeric(10, 2) NOT NULL CHECK (quantity > 0),
    produced_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMIT;
