# Access

Summarize access model outputs

## Usage

    psql $DATABASE_URL --csv -f sql/access_ch_cm_co_pk_sk.sql > access_ch_cm_co_pk_sk.csv
    psql $DATABASE_URL --csv -f sql/access_st.sql > access_st.csv

### Columns:

| Name                     | Description |
|--------------------------|-------------|
| `streamnetwork_km`       | Total stream network length (km) |
| `pa_total_km`            | Length of stream network with no known natural barriers to given species downstream (ie, "potentially accessible") |
| `pa_nobarrier_km`        | Length of potentially accessible stream with no known anthropogenic barrier downstream |
| `pa_potentialbarrier_km` | Length of potentially accessible stream with potential anthropogenic barrier(s) downstream (ie, culvert(s)) |
| `pa_knownbarrier_km`  | Length of potentially accessible stream with assessed (PSCIS) barrier or dam (with no known fish passage structure) downstream |