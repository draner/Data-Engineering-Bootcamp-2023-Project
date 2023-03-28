{{
    config(
        materialized="incremental",
        unique_key="post_id",
        partition_by={
            "field": "post_datetime",
            "data_type": "timestamp",
            "granularity": "hour",
        },
    )
}}

select *
from `pol-it-de-zoomcamp.pol_data.posts_raw`
