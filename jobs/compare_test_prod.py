import pandas as pd

# ----
# compare crossing counts
# ----
crossings_prod = (
    pd.read_csv("https://nrs.objectstore.gov.bc.ca/bchamp/wsg_crossing_summary_current.csv")
    .drop('model_run_id', axis=1)
    .set_index(["watershed_group_code", "crossing_feature_type"])
)
crossings_test = (
    pd.read_csv("https://nrs.objectstore.gov.bc.ca/bchamp/test/wsg_crossing_summary_current.csv")
    .drop('model_run_id', axis=1)
    .set_index(["watershed_group_code", "crossing_feature_type"])
)
# just calc absolute difference - n crossings should mostly be small changes
crossings_test.compare(crossings_prod, result_names=('test', 'prod')).to_csv("wsg_crossings_diff.csv")


# ----
# compare linear habitat - absolute and pct
# ----
linear_prod = (
    pd.read_csv("https://nrs.objectstore.gov.bc.ca/bchamp/wsg_linear_summary_current.csv")
    .set_index(["watershed_group_code"])
    .round()
)
linear_test = (
    pd.read_csv("https://nrs.objectstore.gov.bc.ca/bchamp/test/wsg_linear_summary_current.csv")
    .set_index(["watershed_group_code"])
    .round()
)
# linear absolute diff
linear_test.compare(linear_prod, result_names=('test', 'prod')).to_csv("wsg_linear_diff.csv")
# calc pct diff
pct_change = ((linear_test - linear_prod) / linear_prod) * 100
pct_change.to_csv("wsg_linear_pctdiff.csv")