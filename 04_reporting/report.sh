#!/bin/bash
set -euxo pipefail

psql2csv < sql/accessible_habitat_wsg.sql > accessible_habitat_wsg.csv