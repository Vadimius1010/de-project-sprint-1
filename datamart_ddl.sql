create table analysis.dm_rfm_segments (
	user_id int primary key references production.users (id),
	recency smallint check(recency >= 1 and recency <= 5),
	frequency smallint check(frequency >= 1 and frequency <= 5),
	monetary_value smallint check(monetary_value >= 1 and monetary_value <= 5)
)