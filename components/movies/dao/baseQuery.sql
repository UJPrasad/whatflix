select array_agg(distinct title) as movies
        from movies 
left join movie_cast
    on movies.movie_id = movie_cast.movie_id
left join movie_direction
    on movies.movie_id = movie_direction.movie_id
where 
    language_id in (
        select language_id from language_pref where user_id = $(userId:value)
    )
and
    actor_id in (select actor_id from actor_pref where user_id = $(userId:value))
    and
    director_id in (select director_id from director_pref where user_id = $(userId:value))