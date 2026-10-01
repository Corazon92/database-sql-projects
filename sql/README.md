# PostgreSQL source

Run the scripts in numerical order with PostgreSQL 14 or newer:

```bash
psql -d concrete_plant -f sql/01_schema.sql
psql -d concrete_plant -f sql/02_business_rules.sql
psql -d concrete_plant -f sql/03_views.sql
psql -d concrete_plant -f sql/04_demo_data.sql
```

`04_demo_data.sql` contains fictitious records only and is optional.

## Publication note

The archived coursework file mixed the students' completed work with supplied
teaching functions, incomplete placeholders and real contact data. It is kept
unchanged in the private archive. The files in this directory are a clean
publication edition that reimplements the verified project behaviour with
consistent English names and synthetic examples.

The publication edition covers the relational model, integrity constraints,
views, percentage validation, generated production references and inserts
through `production_view`. Compatibility views named `vue_client`,
`vue_recette` and `vue_production` retain the French field names used by the
archived PcVue queries without exposing the raw workstation export.
