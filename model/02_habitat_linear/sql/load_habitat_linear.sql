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
      when u.spawning_bt is false then -1 -- confirmed/observed as non-habitat
      when coalesce(bt.spawning, false) is true and coalesce(u.spawning_bt, false) is false then 1
      when coalesce(bt.spawning, false) is true and coalesce(u.spawning_bt, false) is true then 2
      when coalesce(bt.spawning, false) is false and coalesce(u.spawning_bt, false) is true then 3
      else 0
    end as spawning_bt,
    case
      when u.spawning_ch is false then -1 -- confirmed/observed as non-habitat
      when coalesce(ch.spawning, false) is true and coalesce(u.spawning_ch, false) is false then 1
      when coalesce(ch.spawning, false) is true and coalesce(u.spawning_ch, false) is true then 2
      when coalesce(ch.spawning, false) is false and coalesce(u.spawning_ch, false) is true then 3
      else 0
    end as spawning_ch,
    case
      when u.spawning_cm is false then -1 -- confirmed/observed as non-habitat
      when coalesce(cm.spawning, false) is true and coalesce(u.spawning_cm, false) is false then 1
      when coalesce(cm.spawning, false) is true and coalesce(u.spawning_cm, false) is true then 2
      when coalesce(cm.spawning, false) is false and coalesce(u.spawning_cm, false) is true then 3
      else 0
    end as spawning_cm,
    case
      when u.spawning_co is false then -1 -- confirmed/observed as non-habitat
      when coalesce(co.spawning, false) is true and coalesce(u.spawning_co, false) is false then 1
      when coalesce(co.spawning, false) is true and coalesce(u.spawning_co, false) is true then 2
      when coalesce(co.spawning, false) is false and coalesce(u.spawning_co, false) is true then 3
      else 0
    end as spawning_co,
    case
      when u.spawning_pk is false then -1 -- confirmed/observed as non-habitat
      when coalesce(pk.spawning, false) is true and coalesce(u.spawning_pk, false) is false then 1
      when coalesce(pk.spawning, false) is true and coalesce(u.spawning_pk, false) is true then 2
      when coalesce(pk.spawning, false) is false and coalesce(u.spawning_pk, false) is true then 3
      else 0
    end as spawning_pk,
    case
      when u.spawning_sk is false then -1 -- confirmed/observed as non-habitat
      when coalesce(sk.spawning, false) is true and coalesce(u.spawning_sk, false) is false then 1
      when coalesce(sk.spawning, false) is true and coalesce(u.spawning_sk, false) is true then 2
      when coalesce(sk.spawning, false) is false and coalesce(u.spawning_sk, false) is true then 3
      else 0
    end as spawning_sk,
    case
      when u.spawning_st is false then -1 -- confirmed/observed as non-habitat
      when coalesce(st.spawning, false) is true and coalesce(u.spawning_st, false) is false then 1
      when coalesce(st.spawning, false) is true and coalesce(u.spawning_st, false) is true then 2
      when coalesce(st.spawning, false) is false and coalesce(u.spawning_st, false) is true then 3
      else 0
    end as spawning_st,
    case
      when u.spawning_wct is false then -1 -- confirmed/observed as non-habitat
      when coalesce(wct.spawning, false) is true and coalesce(u.spawning_wct, false) is false then 1
      when coalesce(wct.spawning, false) is true and coalesce(u.spawning_wct, false) is true then 2
      when coalesce(wct.spawning, false) is false and coalesce(u.spawning_wct, false) is true then 3
      else 0
    end as spawning_wct,

    case
      when u.rearing_bt is false then -1 -- confirmed/observed as non-habitat
      when coalesce(bt.rearing, false) is true and coalesce(u.rearing_bt, false) is false then 1
      when coalesce(bt.rearing, false) is true and coalesce(u.rearing_bt, false) is true then 2
      when coalesce(bt.rearing, false) is false and coalesce(u.rearing_bt, false) is true then 3
      else 0
    end as rearing_bt,
    case
      when u.rearing_ch is false then -1 -- confirmed/observed as non-habitat
      when coalesce(ch.rearing, false) is true and coalesce(u.rearing_ch, false) is false then 1
      when coalesce(ch.rearing, false) is true and coalesce(u.rearing_ch, false) is true then 2
      when coalesce(ch.rearing, false) is false and coalesce(u.rearing_ch, false) is true then 3
      else 0
    end as rearing_ch,
    case
      when u.rearing_co is false then -1 -- confirmed/observed as non-habitat
      when coalesce(co.rearing, false) is true and coalesce(u.rearing_co, false) is false then 1
      when coalesce(co.rearing, false) is true and coalesce(u.rearing_co, false) is true then 2
      when coalesce(co.rearing, false) is false and coalesce(u.rearing_co, false) is true then 3
      else 0
    end as rearing_co,
    case
      when u.rearing_sk is false then -1 -- confirmed/observed as non-habitat
      when coalesce(sk.rearing, false) is true and coalesce(u.rearing_sk, false) is false then 1
      when coalesce(sk.rearing, false) is true and coalesce(u.rearing_sk, false) is true then 2
      when coalesce(sk.rearing, false) is false and coalesce(u.rearing_sk, false) is true then 3
      else 0
    end as rearing_sk,
    case
      when u.rearing_st is false then -1 -- confirmed/observed as non-habitat
      when coalesce(st.rearing, false) is true and coalesce(u.rearing_st, false) is false then 1
      when coalesce(st.rearing, false) is true and coalesce(u.rearing_st, false) is true then 2
      when coalesce(st.rearing, false) is false and coalesce(u.rearing_st, false) is true then 3
      else 0
    end as rearing_st,
    case
      when u.rearing_wct is false then -1 -- confirmed/observed as non-habitat
      when coalesce(wct.rearing, false) is true and coalesce(u.rearing_wct, false) is false then 1
      when coalesce(wct.rearing, false) is true and coalesce(u.rearing_wct, false) is true then 2
      when coalesce(wct.rearing, false) is false and coalesce(u.rearing_wct, false) is true then 3
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