{{ config(materialized="table") }}

with
    old_threads as (select * from `pol-it-de-zoomcamp.deployment.threads`),
    new_threads as (select * from `pol-it-de-zoomcamp.pol_data.threads_raw`)
select *
from new_threads
union all
select *
from old_threads
where old_threads.thread_id not in (select thread_id from new_threads)
order by thread_id
