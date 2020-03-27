#!/bin/bash

set -e
source .env

psql -U ${DB_USER} -d ${DB_NAME} -h ${DB_HOST} -f dev/db/drop-tables.sql

psql -U ${DB_USER} -d ${DB_NAME} -h ${DB_HOST} -f sql/master-schema.sql

psql -U ${DB_USER} -d ${DB_NAME}  -h ${DB_HOST} -c "

create table temp_movies(
    movie_id bigint primary key,
    title text,
    cas jsonb,
    crew jsonb
);

create table temp_mov(
    budget bigint,
    genres json,
    homepage text,
    id bigint primary key,
    keywords json,
    original_language varchar(2),
    original_title text,
    overview text,
    popularity numeric,
    production json,
    production_countries json,
    release text,
    revenue text,
    runtime numeric,
    spoken json,
    status text,
    tagline text,
    title text,
    vote numeric,
    v_count bigint
);

";

psql -U ${DB_USER} -d ${DB_NAME}  -h ${DB_HOST} -c "\copy temp_movies(
    movie_id, 
    title, 
    cas, 
    crew
) from './dev/data/tmdb_5000_credits.csv' delimiter ',' csv header";

psql -U ${DB_USER} -d ${DB_NAME}  -h ${DB_HOST} -c "\copy temp_mov(
    budget,
    genres,
    homepage,
    id,
    keywords,
    original_language,
    original_title,
    overview,
    popularity,
    production,
    production_countries,
    release,
    revenue,
    runtime,
    spoken,
    status,
    tagline,
    title,
    vote,
    v_count
) from './dev/data/tmdb_5000_movies.csv' delimiter ',' csv header";

psql -U ${DB_USER} -d ${DB_NAME}  -h ${DB_HOST} -c "insert into movies(
    movie_id, 
    title, 
    language_id) 
    
    (select id, original_title, original_language from temp_mov);
";

node dev/db/refresh.js

psql -U ${DB_USER} -d ${DB_NAME}  -h ${DB_HOST} -c "

insert into language_pref(user_id, language_code) (
    with cte as(
        select 100 as user_id, language_code from languages where language in ('English', 'Spanish') union
        select 101 as user_id, language_code from languages where language in ('English') union
        select 102 as user_id, language_code from languages where language in ('English') union
        select 103 as user_id, language_code from languages where language in ('English') union
        select 104 as user_id, language_code from languages where language in ('English') union
        select 105 as user_id, language_code from languages where language in ('Spanish') union
        select 106 as user_id, language_code from languages where language in ('English', 'Spanish')
    ) select * from cte
);

insert into actor_pref(user_id, actor_id) (
    with cte as(
        select 100 as user_id, actor_id from actors where actor in (
            'Denzel Washington',
            'Kate Winslet',
            'Emma Suárez',
            'Tom Hanks') union
        select 101 as user_id, actor_id from actors where actor in (
            'Denzel Washington',
            'Anne Hathaway',
            'Tom Hanks'
        ) union
        select 102 as user_id, actor_id from actors where actor in (
            'Uma Thurman',
            'Charlize Theron',
            'John Travolta'
        ) union
        select 103 as user_id, actor_id from actors where actor in (
            'Antonio Banderas',
            'Clint Eastwood',
            'Bruce Willis'
        ) union
        select 104 as user_id, actor_id from actors where actor in (
            'Anthony Hopkins',
            'Adam Sandler',
            'Bruce Willis'
        ) union
        select 105 as user_id, actor_id from actors where actor in (
            'Anthony Hopkins',
            'Bárbara Goenaga',
            'Tenoch Huerta'
        ) union
        select 106 as user_id, actor_id from actors where actor in (
            'Brad Pitt',
            'Robert Downey Jr.',
            'Jennifer Lawrence',
            'Johnny Depp'
        )
    ) select * from cte
);

insert into director_pref(user_id, director_id) (
    with cte as(
        select 100 as user_id, director_id from directors where director in (
            'Steven Spielberg',
            'Martin Scorsese',
            'Pedro Almodóvar'
        ) union
        select 101 as user_id, director_id from directors where director in (
            'Guy Ritchie',
            'Quentin Tarantino' 
        ) union
        select 102 as user_id, director_id from directors where director in (
            'Quentin Tarantino' 
        ) union
        select 103 as user_id, director_id from directors where director in (
            'Stanley Kubrick',
            'Oliver Stone'
        ) union
        select 104 as user_id, director_id from directors where director in (
            'Nora Ephron',
            'Oliver Stone'
        ) union
        select 105 as user_id, director_id from directors where director in (
            'Amat Escalante',
            'Robert Rodriguez'
        ) union
        select 106 as user_id, director_id from directors where director in (
            'Steven Spielberg',
            'Martin Scorsese',
            'Ridley Scott'
        )
    ) select * from cte
);

";