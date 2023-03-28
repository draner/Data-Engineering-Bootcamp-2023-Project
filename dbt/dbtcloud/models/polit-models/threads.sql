{{ config(materialized='incremental',
unique_key = 'thread_id'

) }}

select *
from `pol-it-de-zoomcamp.pol_data.threads_raw`
