CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

insert into analysis.tmp_rfm_monetary_value (user_id, monetary_value)
with t as (
	select user_id,
		   case
	       when o.status = 4 then sum(payment) -- Для анализа нужно отобрать только успешно выполненные заказы.
	       else 0 end monetary_value,
	       row_number() over (partition by user_id 
                              order by case
							           when status = 4 then sum(payment)
							           else 0 end desc) row_num
	from analysis.orders o 
	group by user_id, status 
	order by monetary_value desc
)
select user_id, ntile(5) over (order by monetary_value) monetary_value
from t
where row_num = 1