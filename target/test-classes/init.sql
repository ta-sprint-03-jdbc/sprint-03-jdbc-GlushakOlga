-- Active: 1777903215330@@localhost@5432@example
-- Create tables
DROP TABLE IF EXISTS club_child CASCADE;
DROP TABLE IF EXISTS club CASCADE;
DROP TABLE IF EXISTS clubs CASCADE;
DROP TABLE IF EXISTS child CASCADE;
DROP TABLE IF EXISTS children CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

create table categories
(
    id     bigint generated always as identity primary key,
    avatar varchar not null,
    title  varchar not null unique
);
create table club
(
    id          bigint generated always as identity primary key,
    title       varchar not null,
    description varchar not null,
    image_url   varchar,
    category_id int8 references categories (id)
);
create table child
(
    id         bigint generated always as identity primary key,
    first_name varchar not null,
    last_name  varchar not null,
    birth_date date
);
create table club_child
(
    club_id  int8 references club (id),
    child_id int8 references child (id)
);

-- Clean existing data
truncate table club_child cascade;
truncate table club restart identity cascade;
truncate table child restart identity cascade;
truncate table categories restart identity cascade;

-- Insert categories with descriptive names
insert into categories (title, avatar)
values ('Old Category',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('For Delete Category',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Unique Category',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Second uniquE Category',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Third uniquE Test Category',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Sports uniquE Activities',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Arts & Crafts',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Music',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII'),
       ('Science',
        'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABlBMVEX///+/v7+jQ3Y5AAAADklEQVQI12P4AIX8EAgALgAD/aNpbtEAAAAASUVORK5CYII');

-- Insert clubs with references to categories
insert into club (title, description, image_url, category_id)
values ('Soccer Club', 'Weekly soccer practice and games for children ages 6-12', 'https://example.com/soccer.jpg', 6),
       ('Basketball Club', 'Learn basketball fundamentals and teamwork', 'https://example.com/basketball.jpg', 6),
       ('Painting Workshop', 'Express yourself through colors and canvas', 'https://example.com/painting.jpg', 7),
       ('Guitar Lessons', 'Learn to play guitar from beginner to advanced', 'https://example.com/guitar.jpg', 8),
       ('Robotics Lab', 'Build and program robots while learning STEM concepts', 'https://example.com/robotics.jpg', 9);

-- Insert children with various ages and names
insert into child (first_name, last_name, birth_date)
values ('John', 'Smith', '2010-05-15'),
       ('Emma', 'Johnson', '2012-08-22'),
       ('Michael', 'Williams', '2009-03-10'),
       ('Sophia', 'Brown', '2011-11-30'),
       ('William', 'Jones', '2013-01-25'),
       ('Olivia', 'Garcia', '2008-07-14'),
       ('James', 'Miller', '2014-09-05'),
       ('Ava', 'Davis', '2010-12-18'),
       ('Alexander', 'Rodriguez', '2015-04-03'),
       ('Charlotte', 'Wilson', NULL);

-- Create relationships between clubs and children
insert into club_child (club_id, child_id)
values (1, 1),
       (1, 3),
       (1, 5),
       (2, 3),
       (2, 6),
       (3, 2),
       (3, 4),
       (3, 8),
       (4, 2),
       (4, 7),
       (5, 1),
       (5, 9);