insert into analysis.dm_rfm_segments (user_id, recency, frequency, monetary_value)
select user_id, 
       recency, 
       frequency, 
       monetary_value
from tmp_rfm_recency trr
join tmp_rfm_frequency trf using(user_id)
join tmp_rfm_monetary_value trmv using(user_id)

select *
from dm_rfm_segments drs 
order by user_id 
limit 10

--|user_id|recency|frequency|monetary_value|
--|-------|-------|---------|--------------|
--|0      |1      |3        |4             |
--|1      |4      |3        |3             |
--|2      |2      |4        |5             |
--|3      |2      |3        |3             |
--|4      |4      |3        |3             |
--|5      |5      |5        |5             |
--|6      |1      |3        |5             |
--|7      |4      |2        |2             |
--|8      |1      |1        |3             |
--|9      |1      |3        |2             |
