const pgp = require('pg-promise')();
const dotenv = require('dotenv');
dotenv.config();
const db = pgp(`postgres://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:5432/${process.env.DB_NAME}`);

const loadDb = async () => {
    // directors
    const values = await db.manyOrNone(`select movie_id, crew from temp_movies`);
    const directors = values.reduce((a, c) => { 
        a.push(...c.crew.filter(x => x.job === 'Director')); 
        return a;
    }, []);
    let insQuery = 'with rows as (insert into directors(director_id, director) values'; 
    insQuery += directors.reduce((a, c) => a+=`(${c.id}, '${c.name.replace(/'/g, "''")}'), `, '');
    insQuery = insQuery.substring(0, insQuery.length - 2);
    insQuery += ' on conflict do nothing returning 1) select count(*) from rows';
    console.log('INSERT','0', (await db.oneOrNone(insQuery)).count);

    // actors
    const cast = await db.manyOrNone(`select movie_id, cas from temp_movies`);
    const actors = cast.reduce((a, c) => { 
        a.push(...c.cas); 
        return a;
    }, []);
    insQuery = 'with rows as (insert into actors(actor_id, actor) values'; 
    insQuery += actors.reduce((a, c) => a+=`(${c.id}, '${c.name.replace(/'/g, "''")}'), `, '');
    insQuery = insQuery.substring(0, insQuery.length - 2);
    insQuery += ' on conflict do nothing returning 1) select count(*) from rows';
    console.log('INSERT','0', (await db.oneOrNone(insQuery)).count);

    // md
    const md = values.reduce((a, c) => { 
        a.push(...c.crew.filter(x => x.job === 'Director').map(x => { return {...x, movie_id: c.movie_id} })); 
        return a;
    }, []);
    insQuery = 'with rows as (insert into movie_direction(director_id, movie_id) values'; 
    insQuery += md.reduce((a, c) => a+=`(${c.id}, ${c.movie_id}::bigint), `, '');
    insQuery = insQuery.substring(0, insQuery.length - 2);
    insQuery += ' returning 1) select count(*) from rows';
    console.log('INSERT','0', (await db.oneOrNone(insQuery)).count);

    // mc
    const mc = cast.reduce((a, c) => {
        const cas = c.cas.map(x => { return {...x, movie_id: c.movie_id} }); 
        a.push(...cas); 
        return a;
    }, []);
    insQuery = 'with rows as (insert into movie_cast(actor_id, movie_id) values'; 
    insQuery += mc.reduce((a, c) => a+=`(${c.id}, ${c.movie_id}::bigint), `, '');
    insQuery = insQuery.substring(0, insQuery.length - 2);
    insQuery += ' on conflict do nothing returning 1) select count(*) from rows';
    console.log('INSERT','0', (await db.oneOrNone(insQuery)).count);
}

loadDb();


// select distinct title
// from movies 
// inner join movie_cast
// on movies.movie_id = movie_cast.movie_id
// inner join movie_direction
// on movies.movie_id = movie_direction.movie_id
// inner join languages
// on movies.language_id = languages.language_code
// where 
// language in ('English', 'Spanish') and
// (actor_id in (select actor_id from actors where actor in ('Denzel Washington', 'Kate Winslet', 'Emma Suárez', 'Tom Hanks')) or
// director_id in (select director_id from directors where director in ('Steven Spielberg', 'Martin Scorsese', 'Pedro Almodóvar')));