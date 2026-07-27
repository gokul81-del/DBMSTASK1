use student;
create table students(
RollNo integer primary key,
Name varchar(30),
Gender varchar(30)
);

desc students;

 insert into students values(80, "gokul", "male");
 
 select * from students;
