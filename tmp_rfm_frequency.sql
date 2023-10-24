CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

insert into analysis.tmp_rfm_frequency (user_id, frequency)
with t as (
	select user_id,
		   count(case
	             when status = 4 then 1 -- Для анализа нужно отобрать только успешно выполненные заказы.
	             end) order_count
	from analysis.orders o 
	group by user_id 
	order by order_count desc
)
select user_id, ntile(5) over (order by order_count) frequency
from t