# add pink salmon column to /data/wsg_species_presence.csv by querying the observations table,
# and returning watershed groups with >5 observations since 1990

psql2csv bcfishpass "with wsg as
(select
  watershed_group_code, count(*) as n
from bcfishobs.fiss_fish_obsrvtn_events_sp o
where species_code = 'PK' and observation_date >= '1990-01-01'::date
group by watershed_group_code
having count(*) >= 5
)
select
  a.watershed_group_code,
  a.ch,
  a.co,
  case when wsg.watershed_group_code is not null then true end as pk,
  a.sk,
  a.st,
  a.wct,
  a.bt,
  a.gr,
  a.rb,
  a.notes
from bcfishpass.wsg_species_presence a
left outer join wsg on a.watershed_group_code = wsg.watershed_group_code
order by a.watershed_group_code;" > wsg_species_presence.csv