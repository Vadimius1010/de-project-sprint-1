CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

insert into analysis.tmp_rfm_recency (user_id, recency)
with t as (
	select user_id,
		   status,
		   order_ts,
	       case
           when status = 4 then order_ts -- Для анализа нужно отобрать только успешно выполненные заказы.
           else -- иначе не все 1000 пользователей получат категорию
           (SELECT min(order_ts)
           FROM analysis.orders o) end last_order_dt,
           row_number() over (partition by user_id 
                              order by case
							           when status = 4 then order_ts 
							           else (SELECT min(order_ts)
                                       FROM analysis.orders o) end desc) row_num
	from analysis.orders o 
	order by user_id
)
select user_id, ntile(5) over (order by last_order_dt) recency
from t
where row_num = 1
