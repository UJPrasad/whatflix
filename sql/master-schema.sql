create table users(
    user_id bigserial primary key
);

insert into users(user_id) values
(100),
(101),
(102),
(103),
(104),
(105),
(106);

create table languages(
    language_code varchar(2) primary key,
    language text
);

insert into languages(language_code, language) values
('af', 'Afrikaans'),
('ar', 'Arabic'),
('cn', 'CN'),
('cs', 'Czech'),
('da', 'Danish'),
('de', 'German'),
('el', 'Greek'),
('en', 'English'),
('es', 'Spanish'),
('fa', 'Persian'),
('fr', 'French'),
('he', 'Hebrew'),
('hi', 'Hindi'),
('hu', 'Hungarian'),
('id', 'Indonesian'),
('is', 'Icelandic'),
('it', 'Italian'),
('ja', 'Japanese'),
('ko', 'Korean'),
('ky', 'Kyrgyz'),
('nb', 'Norwegian bokmal'),
('nl', 'Dutch'),
('no', 'Norwegian'),
('pl', 'Polish'),
('ps', 'Pashto'),
('pt', 'Portuguese'),
('ro', 'Romanian'),
('ru', 'Russian'),
('sl', 'Slovenian'),
('sv', 'Swedish'),
('ta', 'Tamil'),
('te', 'Telugu'),
('th', 'Thai'),
('tr', 'Turkish'),
('vi', 'Vietnamese'),
('xx', 'XX'),
('zh', 'Chinese');

create table directors(
    director_id bigint primary key,
    director text
);

create table actors(
    actor_id bigint primary key,
    actor text
);

create table movies(
    movie_id bigint primary key,
    title text,
    language_id varchar(2) references languages(language_code)
);

create table movie_direction(
    md_id bigserial primary key,
    director_id bigint references directors(director_id),
    movie_id bigint references movies(movie_id),
    unique (director_id, movie_id)
);

create table movie_cast(
    mc_id bigserial primary key,
    actor_id bigint references actors(actor_id),
    movie_id bigint references movies(movie_id),
    unique (actor_id, movie_id)
);

create table language_pref(
    user_id bigint references users(user_id),
    language_code varchar(2) references languages(language_code),
    unique(user_id, language_code)
);

create table actor_pref(
    user_id bigint references users(user_id),
    actor_id bigint references actors(actor_id),
    unique(user_id, actor_id)
);

create table director_pref(
    user_id bigint references users(user_id),
    director_id bigint references directors(director_id),
    unique(user_id, director_id)
);