#!/bin/bash
set -euxo pipefail

BARRIERS=`ls sql/barriers_*.sql`

echo $BARRIERS
