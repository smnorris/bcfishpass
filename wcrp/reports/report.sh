#!/bin/bash
set -euxo pipefail

mkdir -p reports

psql2csv < sql/watershed_summary.sql > reports/watershed_summary.csv
psql2csv < sql/barrier_extent.sql > reports/barrier_extent.csv
psql2csv < sql/barrier_severity.sql > reports/barrier_severity.csv

# just one value for each of these
psql2csv < sql/dci_elkr_above_elko.sql > reports/dci_elkr_above_elko.csv
psql2csv < sql/dci_elkr_below_elko.sql > reports/dci_elkr_below_elko.csv