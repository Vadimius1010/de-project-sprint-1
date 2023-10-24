create or replace view analysis.orders as
select o.order_id,
       dttm as order_ts,
       o.user_id,
       bonus_payment,
       payment,
       cost,
       bonus_grant,
       status_id as status
from production.orders o 
left join production.orderstatuslog o2 
          on o.order_id = o2.order_id 
          and dttm = (select max(dttm)
                      from production.orderstatuslog o3
                      where o3.order_id = o.order_id)
	   