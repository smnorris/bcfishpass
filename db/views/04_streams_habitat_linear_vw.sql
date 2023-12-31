drop view if exists bcfishpass.streams_habitat_linear_vw;
create view bcfishpass.streams_habitat_linear_vw as
select
  s.segmented_stream_id,
  coalesce(u.spawning_bt, bt.spawning, false) as spawning_bt,
  coalesce(u.spawning_ch, ch.spawning, false) as spawning_ch,
  coalesce(u.spawning_cm, cm.spawning, false) as spawning_cm,
  coalesce(u.spawning_co, co.spawning, false) as spawning_co,
  coalesce(u.spawning_pk, pk.spawning, false) as spawning_pk,
  coalesce(u.spawning_sk, sk.spawning, false) as spawning_sk,
  coalesce(u.spawning_st, st.spawning, false) as spawning_st,
  coalesce(u.spawning_wct, wct.spawning, false) as spawning_wct,
  coalesce(u.rearing_bt, bt.rearing, false) as rearing_bt,
  coalesce(u.rearing_ch, ch.rearing, false) as rearing_ch,
  coalesce(u.rearing_co, co.rearing, false) as rearing_co,
  coalesce(u.rearing_sk, sk.rearing, false) as rearing_sk,
  coalesce(u.rearing_st, st.rearing, false) as rearing_st,
  coalesce(u.rearing_wct, wct.rearing, false) as rearing_wct
from bcfishpass.streams s
left outer join bcfishpass.habitat_linear_bt bt on s.segmented_stream_id = bt.segmented_stream_id
left outer join bcfishpass.habitat_linear_ch ch on s.segmented_stream_id = ch.segmented_stream_id
left outer join bcfishpass.habitat_linear_cm cm on s.segmented_stream_id = cm.segmented_stream_id
left outer join bcfishpass.habitat_linear_co co on s.segmented_stream_id = co.segmented_stream_id
left outer join bcfishpass.habitat_linear_pk pk on s.segmented_stream_id = pk.segmented_stream_id
left outer join bcfishpass.habitat_linear_sk sk on s.segmented_stream_id = sk.segmented_stream_id
left outer join bcfishpass.habitat_linear_st st on s.segmented_stream_id = st.segmented_stream_id
left outer join bcfishpass.habitat_linear_wct wct on s.segmented_stream_id = wct.segmented_stream_id
left outer join bcfishpass.habitat_linear_user u on s.segmented_stream_id = u.segmented_stream_id;