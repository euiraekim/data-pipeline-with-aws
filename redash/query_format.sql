SELECT *
FROM $(table_name)
WHERE date_trunc('hour', date) BETWEEN to_timestamp('{{start_date}}', 'YYYY-MM-DD HH24') AND to_timestamp('{{end_date}}', 'YYYY-MM-DD HH24');
