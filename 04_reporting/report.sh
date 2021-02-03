#!/bin/bash
set -euxo pipefail

psql2csv < sql/watershed_summary.sql > reports/watershed_summary.csv
psql2csv < sql/wcrp_barrier_extent.sql > reports/wcrp_barrier_extent.csv
psql2csv < sql/wcrp_barrier_severity.sql > reports/wcrp_barrier_severity.csv