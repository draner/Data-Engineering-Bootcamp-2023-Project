{{ config(
    materialized='table',
    partition_by={
      "field": "post_datetime",
      "data_type": "timestamp",
      "granularity": "day"
    }
)}}

with
    old_posts as (select * from `pol-it-de-zoomcamp.deployment.posts`),
    new_posts as (select * from `pol-it-de-zoomcamp.pol_data.posts_raw`)
select *
from new_posts
union all
select *
from old_posts
where old_posts.post_id not in (select post_id from new_posts)