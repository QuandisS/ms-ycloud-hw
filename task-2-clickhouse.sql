-- Группировка по payment_status: подсчитываем количество заказов, сумму (total_amount), среднюю стоимость заказа.
SELECT 
    payment_status,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_amount_sum,
    AVG(total_amount) AS avg_order_amount
FROM orders
GROUP BY payment_status
ORDER BY order_count DESC;

-- JOIN с order_items: подсчитать общее количество товаров, общую сумму, среднюю цену за продукт
SELECT 
    o.order_id,
    COUNT(oi.item_id) AS total_items,
    SUM(oi.product_price * oi.quantity) AS total_order_value,
    AVG(oi.product_price) AS avg_product_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.payment_status != 'cancelled'
GROUP BY o.order_id
ORDER BY total_order_value DESC;

-- Отдельно посмотреть статистику по датам (количество заказов и их суммарная стоимость за каждый день).
SELECT 
    toDate(order_date) AS order_day,
    COUNT(*) AS order_count,
    SUM(total_amount) AS daily_total_amount
FROM orders
WHERE payment_status != 'cancelled'  -- Исключаем отмененные заказы
GROUP BY order_day
ORDER BY order_day;

-- Выделить «самых активных» пользователей (по сумме заказов или по количеству заказов).
-- По сумме заказов
SELECT 
    user_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent
FROM orders
WHERE payment_status = 'paid'
GROUP BY user_id
ORDER BY total_spent DESC
LIMIT 5;

-- По количеству заказов
SELECT 
    user_id,
    COUNT(*) AS order_count,
    SUM(total_amount) AS total_spent
FROM orders
WHERE payment_status = 'paid'
GROUP BY user_id
ORDER BY order_count DESC
LIMIT 5;