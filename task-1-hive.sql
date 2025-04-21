-- Фильтрация «хороших» валют  
SELECT 
    currency,
    SUM(amount) AS total_amount
FROM 
    transactions_v2
WHERE 
    currency IN ('USD', 'EUR', 'RUB')
GROUP BY 
    currency;

-- Подсчёт количества мошеннических (is_fraud=1) и нормальных (is_fraud=0) транзакций, суммарной суммы и среднего чека
SELECT 
    is_fraud,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount
FROM 
    transactions_v2
GROUP BY 
    is_fraud;

-- Группировка по датам с вычислением ежедневного количества транзакций, суммарного объёма и среднего amount.
SELECT 
    DATE(transaction_date) AS transaction_day,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount,
    AVG(amount) AS average_amount
FROM 
    transactions_v2
GROUP BY 
    DATE(transaction_date)
ORDER BY 
    transaction_day;

-- Использование временных функций (например, извлечение дня/месяца из transaction_date) и анализ транзакций по временным интервалам.
SELECT 
    YEAR(transaction_date) AS year,
    MONTH(transaction_date) AS month,
    DAY(transaction_date) AS day,
    HOUR(transaction_date) AS hour,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM 
    transactions_v2
GROUP BY 
    YEAR(transaction_date),
    MONTH(transaction_date),
    DAY(transaction_date),
    HOUR(transaction_date)
ORDER BY 
    year, month, day, hour;

-- JOIN с таблицей logs_v2 по transaction_id, чтобы посчитать количество логов на одну транзакцию, выделить самые частые категории category 

-- Подсчет логов для транзакции и поиск наиболее частых категорий
SELECT 
    t.transaction_id,
    COUNT(l.log_id) AS log_count,
    COLLECT_LIST(DISTINCT l.category) AS categories,
    COUNT(DISTINCT l.category) AS unique_categories
FROM 
    transactions_v2 t
LEFT JOIN 
    logs_v2 l ON t.transaction_id = l.transaction_id
GROUP BY 
    t.transaction_id
ORDER BY 
    log_count DESC;

-- Просто самый частые категории
SELECT 
    l.category,
    COUNT(*) AS category_count
FROM 
    transactions_v2 t
JOIN 
    logs_v2 l ON t.transaction_id = l.transaction_id
GROUP BY 
    l.category
ORDER BY 
    category_count DESC;