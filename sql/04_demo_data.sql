INSERT INTO admin_bdd.customer (name, address, phone)
VALUES
    ('Demo Construction', '10 Example Street', '+33 4 00 00 00 01'),
    ('Sample Works', '20 Test Avenue', '+33 4 00 00 00 02')
ON CONFLICT (name) DO NOTHING;

INSERT INTO admin_bdd.recipe (
    name,
    aggregate_pct,
    water_pct,
    admixture_pct,
    cement_pct
)
VALUES ('Demo C30', 52.00, 20.00, 2.00, 26.00)
ON CONFLICT (name) DO NOTHING;

INSERT INTO admin_bdd.production_view (
    customer_name,
    recipe_name,
    quantity
)
VALUES ('Demo Construction', 'Demo C30', 5.00);
