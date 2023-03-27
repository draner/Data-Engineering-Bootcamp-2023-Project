{{
  config(
    materialized='table'
  )
}}

WITH old_threads AS
  (SELECT *
   FROM `pol-it-de-zoomcamp.pol_data.threads`),
     new_threads AS
  (SELECT *
   FROM `pol-it-de-zoomcamp.pol_data.threads_raw`)
SELECT *
FROM new_threads
UNION ALL
SELECT *
FROM old_threads
WHERE old_threads.thread_id not in
    (SELECT thread_id
     FROM new_threads)
ORDER BY thread_id

