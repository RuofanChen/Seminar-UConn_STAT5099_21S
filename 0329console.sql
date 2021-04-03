show databases;
DROP DATABASE school;
use school;
-- March.29th SQl for Data Science by Ruofan Chen

-- slide page 10
-- create table 'student'
create table student(
    studentID char(4) not null,
    firstName varchar(255) not null,
    lastName varchar(255) not null,
    DateofBirth date not null,
    gender varchar(6) not null,
    primary key (studentID)
);

-- slide page 11
-- write data into table 'student'
insert into student (studentid, firstName,lastName, dateofbirth, gender)
              values
              ('0001','William','Patterson','1989-01-01','Male'),
              ('0002','William','Patterson','1990-12-21','Female'),
              ('0003','Foon Yue','Tseng','1991-12-21','Male'),
              ('0004','George','Vanauf','1990-05-20','Male');

-- slide page 12
-- create table 'grade'
create table grade(
    studentID char(4) not null,
    courseID char(4) not null,
    score int,
    primary key (studentID,courseID)
);

-- create table 'course'
create table course(
    courseID char(4) not null,
    courseName varchar(255) not null,
    facultyID char(4),
    primary key (courseID)
);

-- create table 'faculty'
create table faculty(
    facultyID char(4) not null,
    facultyFirstName varchar(255),
    facultyLastName varchar(255),
    primary key (facultyID)
);


-- write data into table 'grade'
insert into grade (studentid, courseid, score)
            values
            ('0001','0001',80),
            ('0001','0002',90),
            ('0001','0003',99),
            ('0002','0002',60),
            ('0002','0003',80),
            ('0003','0001',80),
            ('0003','0002',80),
            ('0003','0003',80);

-- write data into table 'course'
insert into course (courseid, coursename, facultyID)
            values
            ('0001','English','0002'),
            ('0002','Math','0001'),
            ('0003','Geography','0003');

-- write data into table 'faculty'
insert into faculty (facultyID, facultyFirstName,facultyLastName)
            values
            ('0001','Larry','Bott'),
            ('0002','Peter','Marsh'),
            ('0003',null,null),
            ('0004','','');

-- create connections
-- add foreign key
alter table grade
add foreign key (studentID) references student (studentID);

alter table grade
add foreign key (courseID) references course (courseID);

alter table course
add foreign key (facultyID) references faculty (facultyID);


-- page 13
-- select 'firstName', 'lastName', and 'gender' columns from the 'student' table
select firstName,lastName,gender
from student;

select firstName,lastName, gender as stu_gen
from student;

-- select all columns from the 'student' table
select *
from student;

-- page 14
-- select only the distinct values from the 'firstName' column from the 'student' table
select distinct firstName
from student;


-- exercise
-- select student ID, score and calculate its percent grade
select studentID,
       score,
       score/100 as per_sco
from grade;

-- page 16
-- select student ID whose score is lower than 85, show their ID and score
select studentID,score
from grade
where score<85;




/* select ID of student who's first name is 'William'*/
select firstName, studentid
from student
where firstName='William';



-- select student(firstName, lastName) whose date of birth is before 1990-01-01
select firstName,lastName,dateofbirth
from student
where dateofbirth<'1990-01-01';



-- page 17
/*select student(lastName, firstName and gender) whose firstName is
  'William' or 'George', and gender is female */
select lastName,firstName,gender
from student
where (firstName='William' or firstName='George')
and gender='Female';

-- page 18
-- select student (ID and score) whose score is between [60,90]
-- use of 'between'
select studentID,score
from grade
where score between 60 and 90;
-- is same as above
select studentID,score
from grade
where score>=60 and score<=90;

-- page 19
-- select student(firstName and gender) whose firstName is 'George' or 'Foon Yue'
-- in or not in
select firstName,gender
from student
where firstName in ('George','Foon Yue');

-- page 21
-- like
-- find student whose First Name begins with 'G'
select firstName,studentid
from student
where firstName like 'G%';
-- find student whose last Name ends with 'f'
select lastName,studentid
from student
where lastName like '%f';


-- find student whose first Name includes 'i'
select firstName,studentid
from student
where firstName like '%i%';

-- find student whose last Name begins with T and Name has 5 characters
select *
from student
where lastName like 'T____';

-- page 22
-- count
-- find the number of facultyLastName
select count(facultyLastName)
from faculty;

-- find the number of records of all faculty
select count(*)
from faculty;

-- exercise
-- find the number of distinct firstName of students
select count(distinct firstName)
from student;


-- page 24
-- calculate sum, average, minimum value, maximum value of score
select sum(score),avg(score),min(score),max(score)
from grade;

-- calculate total score of course 0002
select sum(score)
from grade
where courseID='0002';


-- page 25
-- list the number of males and females of student
select gender,count(*)
from student
group by gender;

/* list the number of males and females of students whose date of birth is
   after 1990-01-01
 */
select gender,count(*)
from student
where DateofBirth>'1990-01-01'
group by gender;





-- page 26
-- having
-- list number of males and females which number is greater than 2
select gender,count(*)
from student
group by gender
having count(*)>2;

/*count number of students whose name (lastName and firstName)
  appear in the student table more than once
 */
select lastName,firstName,count(*)
from student
group by lastName, firstName
having count(*)>1;


-- page 27
-- select all scores from the 'grade' table, sorted by score and course ID column
select *
from grade
order by score asc,
courseid desc;


-- order null: if you want to check if there's a null
-- select all the faculty's last name from 'faculty' table
select *
from faculty
order by facultyLastName;

-- limit
select *
from grade
limit 2;

/* calculate average score of every course,
   sorted by avg(score) asc and course_id desc
 */
select courseID,avg(score)
from grade
group by courseID
order by avg(score) asc,
         courseID desc;




-- page 28
-- Which students have higher score than the minimum score in class 0002
select score
from grade
where courseID='0002';

select studentID,score,courseID
from grade
where score>60;

select studentID,score,courseID
from grade
where score>any(
    select score
from grade
where courseID='0002'
);

-- or
select min(score)
from grade
where courseID='0002';

select studentID,score,courseID
from grade
where score>(select min(score)
from grade
where courseID='0002');

-- page 30
-- Which students have higher score than the maximum score in class 0002
select studentID,score,courseID
from grade
where score>all(
    select score
from grade
where courseID='0002'
);



-- find studentID and its score, and list the average score in column 3
select studentID,score,(
    select avg(score)
    from grade
    )
from grade;





-- page 32
-- inner join
-- list student name, ID, and the course they selected
select a.studentID,a.firstName, a.lastName,b.courseID
from student as a inner join grade as b
on a.studentID=b.studentID;

-- page 33
-- left join
-- select all student, and any course they might have:
select a.studentID,a.lastName,a.firstName,b.courseID
from student as a left join grade as b
on a.studentID=b.studentID;

-- page 34
-- right join
-- select all courseID and any student whose might choose the course
select a.studentID,a.firstName,a.lastName,b.courseID
from student as a right join grade as b
on a.studentID=b.studentID;

-- page 35
-- exercise
-- list all students ID,Name,number of courses they choose,and their total score
select a.studentID,a.firstName,a.lastName,count(courseID),sum(score)
from student as a left join grade as b
on a.studentID=b.studentID
group by a.studentID;





-- page 36
-- create a new table 'course1'
create table course1(
    courseID char(4) not null,
    courseName varchar(255) not null,
    facultyID char(4),
    primary key (courseID)
);

insert into course1(courseID, courseName, facultyID)
values
('0001','English','0002'),
('0004','CS','0004'),
('0005','DataBase','0005');

-- union
select courseID,courseName
from course
union
select courseID,courseName
from course1
order by courseID;

