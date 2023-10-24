CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

with t as (
	select user_id, max(order_ts) last_order_dt
	from analysis.orders o 
	where status = 4
	group by user_id 
	order by user_id
)
select *, ntile(5) over (order by last_order_dt)
from t
left join
(WITH rc AS
  (SELECT u.id,
          o.status,
          o.order_ts,
          CASE
              WHEN o.status = 4 THEN o.order_ts
              ELSE
                     (SELECT MIN(o2.order_ts)
                      FROM production.orders o2)
          END AS order_time,
          row_number() OVER (PARTITION BY u.id
                      ORDER BY CASE
                            WHEN o.status = 4 THEN o.order_ts
                                ELSE
                                    (SELECT MIN(o2.order_ts)
                                     FROM production.orders o2)
                             END DESC) AS row_number
   FROM analysis.users u
   LEFT JOIN analysis.orders o ON u.id = o.user_id
   ORDER BY u.id ASC)
SELECT rc.id,
       ntile(5) OVER (
                ORDER BY rc.order_time) AS recency
FROM rc
WHERE rc.row_number = 1) aaa on aaa.id = t.user_id

select *
from analysis.orders o 

with t as (
	select user_id, max(order_ts) last_order_dt
	from analysis.orders o 
	where status = 4
	group by user_id 
	order by user_id
),
f as (select *, ntile(5) over (order by last_order_dt)
from t)
select ntile, count(ntile) from f
group by 1

with t as (
	select user_id,
		   status,
		   order_ts,
	       case
           when o.status = 4 then o.order_ts -- Для анализа нужно отобрать только успешно выполненные заказы.
           else -- иначе не все 1000 пользователей получат категорию
           (SELECT min(o.order_ts)
           FROM analysis.orders o) end last_order_dt,
           row_number() over (partition by user_id 
                              order by case
							           when o.status = 4 then o.order_ts 
							           else (SELECT min(o.order_ts)
                                       FROM analysis.orders o) end desc) row_num
	from analysis.orders o 
	right join analysis.users u on u.id = o.user_id
	order by user_id
)
select user_id, ntile(5) over (order by last_order_dt)
from t
where row_num = 1

WITH rc AS
  (SELECT u.id,
          o.status,
          o.order_ts,
          CASE
              WHEN o.status = 4 THEN o.order_ts
              ELSE
                     (SELECT MIN(o2.order_ts)
                      FROM production.orders o2)
          END AS order_time,
          row_number() OVER (PARTITION BY u.id
                      ORDER BY CASE
                            WHEN o.status = 4 THEN o.order_ts
                                ELSE
                                    (SELECT MIN(o2.order_ts)
                                     FROM production.orders o2)
                             END DESC) AS row_number
   FROM analysis.users u
   LEFT JOIN analysis.orders o ON u.id = o.user_id
   ORDER BY u.id ASC)
SELECT rc.id,
       ntile(5) OVER (
                ORDER BY rc.order_time) AS recency
FROM rc
WHERE rc.row_number = 1
