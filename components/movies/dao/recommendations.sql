select 
	u.user_id as user,
	(
		select 
			case when 
				length((array_agg(distinct title))[1]) > 0
    			then (array_agg(distinct title))[1:3] 
    		else 
				array[]::text[] 
			end 
			as movies
        from movies 
		left join movie_cast
    		on movies.movie_id = movie_cast.movie_id
		left join movie_direction
    		on movies.movie_id = movie_direction.movie_id
		where 
    		language_id in (
        		select language_id from language_pref where user_id = u.user_id
    		)
		and
    		actor_id in (select actor_id from actor_pref where user_id = u.user_id)
    	and
    	director_id in (select director_id from director_pref where user_id = u.user_id)
	)
from users u;