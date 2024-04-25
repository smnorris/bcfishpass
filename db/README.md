# db setup

Create database schema.

Generally speaking:
- functions/schemas/tables/views defined here are for sources and outputs
- tables downloaded from BC WFS is defined elsewhere via `bcdata bc2pg`
- bcfishpass internal tables are created by model scripts

## Usage

Call sql via scripts `/jobs/setup` and/or `jobs/upgrade`
