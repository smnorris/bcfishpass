-- output:
-- -1 known non spawn/rear; 
-- 0  non spawn/rear; (default) 
-- 1  modelled spawn/rear; 
-- 2  modelled and observed spawn/rear; 
-- 3  observed spawn/rear (not modelled)

begin;

  truncate bcfishpass.streams_habitat_linear;

  insert into bcfishpass.streams_habitat_linear (
    segmented_stream_id ,
    spawning_bt         ,
    spawning_ch         ,
    spawning_cm         ,
    spawning_co         ,
    spawning_pk         ,
    spawning_sk         ,
    spawning_st         ,
    spawning_wct        ,
    rearing_bt          ,
    rearing_ch          ,
    rearing_co          ,
    rearing_sk          ,
    rearing_st          ,
    rearing_wct         
  )

  select
    s.segmented_stream_id,
    case
      when coalesce(u.spawning_bt, 0) = -4 then -4
      when coalesce(u.spawning_bt, 0) = -1 then -1
      when coalesce(bt.spawning, false) is true and coalesce(u.spawning_bt, 0) = 0 then 1
      when coalesce(bt.spawning, false) is true and coalesce(u.spawning_bt, 0) = 1 then 2
      when coalesce(bt.spawning, false) is false and coalesce(u.spawning_bt, 0) = 1 then 3
      else 0
    end as spawning_bt,
    case
      when coalesce(u.spawning_ch, 0) = -4 then -4
      when coalesce(u.spawning_ch, 0) = -1 then -1
      when coalesce(ch.spawning, false) is true and coalesce(u.spawning_ch, 0) = 0 then 1
      when coalesce(ch.spawning, false) is true and coalesce(u.spawning_ch, 0) = 1 then 2
      when coalesce(ch.spawning, false) is false and coalesce(u.spawning_ch, 0) = 1 then 3
      else 0
    end as spawning_ch,
    case
      when coalesce(u.spawning_cm, 0) = -4 then -4
      when coalesce(u.spawning_cm, 0) = -1 then -1
      when coalesce(cm.spawning, false) is true and coalesce(u.spawning_cm, 0) = 0 then 1
      when coalesce(cm.spawning, false) is true and coalesce(u.spawning_cm, 0) = 1 then 2
      when coalesce(cm.spawning, false) is false and coalesce(u.spawning_cm, 0) = 1 then 3
      else 0
    end as spawning_cm,
    case
      when coalesce(u.spawning_co, 0) = -4 then -4
      when coalesce(u.spawning_co, 0) = -1 then -1
      when coalesce(co.spawning, false) is true and coalesce(u.spawning_co, 0) = 0 then 1
      when coalesce(co.spawning, false) is true and coalesce(u.spawning_co, 0) = 1 then 2
      when coalesce(co.spawning, false) is false and coalesce(u.spawning_co, 0) = 1 then 3
      else 0
    end as spawning_co,
    case
      when coalesce(u.spawning_pk, 0) = -4 then -4
      when coalesce(u.spawning_pk, 0) = -1 then -1
      when coalesce(pk.spawning, false) is true and coalesce(u.spawning_pk, 0) = 0 then 1
      when coalesce(pk.spawning, false) is true and coalesce(u.spawning_pk, 0) = 1 then 2
      when coalesce(pk.spawning, false) is false and coalesce(u.spawning_pk, 0) = 1 then 3
      else 0
    end as spawning_pk,
    case
      when coalesce(u.spawning_sk, 0) = -4 then -4
      when coalesce(u.spawning_sk, 0) = -1 then -1
      when coalesce(sk.spawning, false) is true and coalesce(u.spawning_sk, 0) = 0 then 1
      when coalesce(sk.spawning, false) is true and coalesce(u.spawning_sk, 0) = 1 then 2
      when coalesce(sk.spawning, false) is false and coalesce(u.spawning_sk, 0) = 1 then 3
      else 0
    end as spawning_sk,
    case
      when coalesce(u.spawning_st, 0) = -4 then -4
      when coalesce(u.spawning_st, 0) = -1 then -1
      when coalesce(st.spawning, false) is true and coalesce(u.spawning_st, 0) = 0 then 1
      when coalesce(st.spawning, false) is true and coalesce(u.spawning_st, 0) = 1 then 2
      when coalesce(st.spawning, false) is false and coalesce(u.spawning_st, 0) = 1 then 3
      else 0
    end as spawning_st,
    case
      when coalesce(u.spawning_wct, 0) = -4 then -4
      when coalesce(u.spawning_wct, 0) = -1 then -1
      when coalesce(wct.spawning, false) is true and coalesce(u.spawning_wct, 0) = 0 then 1
      when coalesce(wct.spawning, false) is true and coalesce(u.spawning_wct, 0) = 1 then 2
      when coalesce(wct.spawning, false) is false and coalesce(u.spawning_wct, 0) = 1 then 3
      else 0
    end as spawning_wct,
    case
      when coalesce(u.rearing_bt, 0) = -4 then -4
      when coalesce(u.rearing_bt, 0) = -1 then -1
      when coalesce(bt.rearing, false) is true and coalesce(u.rearing_bt, 0) = 0 then 1
      when coalesce(bt.rearing, false) is true and coalesce(u.rearing_bt, 0) = 1 then 2
      when coalesce(bt.rearing, false) is false and coalesce(u.rearing_bt, 0) = 1 then 3
      else 0
    end as rearing_bt,
    case
      when coalesce(u.rearing_ch, 0) = -4 then -4
      when coalesce(u.rearing_ch, 0) = -1 then -1
      when coalesce(ch.rearing, false) is true and coalesce(u.rearing_ch, 0) = 0 then 1
      when coalesce(ch.rearing, false) is true and coalesce(u.rearing_ch, 0) = 1 then 2
      when coalesce(ch.rearing, false) is false and coalesce(u.rearing_ch, 0) = 1 then 3
      else 0
    end as rearing_ch,
    case
      when coalesce(u.rearing_co, 0) = -4 then -4
      when coalesce(u.rearing_co, 0) = -1 then -1
      when coalesce(co.rearing, false) is true and coalesce(u.rearing_co, 0) = 0 then 1
      when coalesce(co.rearing, false) is true and coalesce(u.rearing_co, 0) = 1 then 2
      when coalesce(co.rearing, false) is false and coalesce(u.rearing_co, 0) = 1 then 3
      else 0
    end as rearing_co,
    case
      when coalesce(u.rearing_sk, 0) = -4 then -4
      when coalesce(u.rearing_sk, 0) = -1 then -1
      when coalesce(sk.rearing, false) is true and coalesce(u.rearing_sk, 0) = 0 then 1
      when coalesce(sk.rearing, false) is true and coalesce(u.rearing_sk, 0) = 1 then 2
      when coalesce(sk.rearing, false) is false and coalesce(u.rearing_sk, 0) = 1 then 3
      else 0
    end as rearing_sk,
    case
      when coalesce(u.rearing_st, 0) = -4 then -4
      when coalesce(u.rearing_st, 0) = -1 then -1
      when coalesce(st.rearing, false) is true and coalesce(u.rearing_st, 0) = 0 then 1
      when coalesce(st.rearing, false) is true and coalesce(u.rearing_st, 0) = 1 then 2
      when coalesce(st.rearing, false) is false and coalesce(u.rearing_st, 0) = 1 then 3
      else 0
    end as rearing_st,
    case
      when coalesce(u.rearing_wct, 0) = -4 then -4
      when coalesce(u.rearing_wct, 0) = -1 then -1
      when coalesce(wct.rearing, false) is true and coalesce(u.rearing_wct, 0) = 0 then 1
      when coalesce(wct.rearing, false) is true and coalesce(u.rearing_wct, 0) = 1 then 2
      when coalesce(wct.rearing, false) is false and coalesce(u.rearing_wct, 0) = 1 then 3
      else 0
    end as rearing_wct
  from bcfishpass.streams s
  left outer join bcfishpass.habitat_linear_bt bt on s.segmented_stream_id = bt.segmented_stream_id
  left outer join bcfishpass.habitat_linear_ch ch on s.segmented_stream_id = ch.segmented_stream_id
  left outer join bcfishpass.habitat_linear_cm cm on s.segmented_stream_id = cm.segmented_stream_id
  left outer join bcfishpass.habitat_linear_co co on s.segmented_stream_id = co.segmented_stream_id
  left outer join bcfishpass.habitat_linear_pk pk on s.segmented_stream_id = pk.segmented_stream_id
  left outer join bcfishpass.habitat_linear_sk sk on s.segmented_stream_id = sk.segmented_stream_id
  left outer join bcfishpass.habitat_linear_st st on s.segmented_stream_id = st.segmented_stream_id
  left outer join bcfishpass.habitat_linear_wct wct on s.segmented_stream_id = wct.segmented_stream_id
  left outer join bcfishpass.streams_habitat_known u on s.segmented_stream_id = u.segmented_stream_id;

commit;