**Задача - построить витрину для RFM-анализа**

Каждого клиента оценивают по трём факторам:

- Recency (пер. «давность») — сколько времени прошло с момента последнего заказа. Фактор Recency измеряется по последнему заказу. Распределение клиентов происходит по шкале от одного до пяти, где значение 1 получат те, кто либо вообще не делал заказов, либо делал их очень давно, а 5 — те, кто заказывал относительно недавно.
- Frequency (пер. «частота») — количество заказов. Фактор Frequency оценивается по количеству заказов. Распределение клиентов происходит по шкале от одного до пяти, где значение 1 получат клиенты с наименьшим количеством заказов, а 5 — с наибольшим.
- Monetary Value (пер. «денежная ценность») — сумма затрат клиента. Фактор Monetary Value оценивается по потраченной сумме. Распределение клиентов происходит по шкале от одного до пяти, где значение 1 получат клиенты с наименьшей суммой, а 5 — с наибольшей.

**Требования:**
- Витрина должна располагаться в той же базе в схеме **analysis**
- Витрина должна состоять из таких полей:
    1. user_id
    2. recency (число от 1 до 5)
    3. frequency (число от 1 до 5)
    4. monetary_value (число от 1 до 5)
- В витрине нужны данные с начала 2022 года.
- Обновления не нужны.
- Успешно выполненный заказ - это заказ со статусом Closed.

Для расчёта каждого из трёх факторов используются следующие поля:
- Recency: поле **order_ts** из таблицы **orders**
- Frequency: поле **user_id** для группировки и расчёта количества заказов на пользователя из таблицы **orders**
- Monetary Value: поле **payment**, поле **user_id** для группировки из таблицы **orders**