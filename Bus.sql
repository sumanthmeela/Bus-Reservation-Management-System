create database roadwaytravels;

use roadwaytravels;

create table bus(
                 bid int primary key,
                 bname varchar(20),
                 cost int, source varchar(20),
                 destination varchar(20),
                 jdate date,avail int,alloc int);

create table passenger( 
					pid int primary key,
                    pname varchar(20),
                    age int,phoneno long,
                    gender varchar(10),
                    email varchar(20));

insert into bus values(10,'Luxury',200,'Hyderabad','Karimnagar','2022-07-10',30,0);

insert into bus values(11,'Orange',400,'Hyderabad','Tirupathi','2022-07-12',30,0);

insert into bus values(12,'Deluxe',500,'Hyderabad','Vizag','2022-07-13',30,0);

insert into bus values(13,'Garuda',300,'Hyderabad','Rajamundry','2022-07-19',30,0);

insert into bus values(14,'Volvo',400,'Hyderabad','Warangal','2022-07-17',30,0);

select * from bus;

insert into passenger values(1001,'Prakash',22,9492172489,'Male','prakash@gmail.com');

insert into passenger values(1002,'Akshay',21,8124134519,'Male','akshay@gmail.com');

insert into passenger values(1003,'Rahul',25,7331089431,'Male','rahul@outlook.com');

insert into passenger values(1004,'Sahithi',21,9110285671,'Female','sahithi@yahoo.com');

insert into passenger values(1005,'Lahari',32,8102113674,'Female','lahari@gmail.com');

select * from passenger;

create table reservation(
                         rid int auto_increment primary key,
                         bid int,pid int,jdate1 date,rdate date,
                         nosa int,source1 varchar(20)
                         ,destination1 varchar(20),status varchar(20)
                         ,foreign key(bid) references bus(bid),
                         foreign key(pid) references passenger(pid));
                         
create table ticket(
                    tid int auto_increment primary key,bid int,
                    pid int,source2 varchar(20),destination2 varchar(20),
                    jdate2 date,nosa1 int,amount int,
                    foreign key(bid) references bus(bid),
                    foreign key(pid) references passenger(pid)); 
                    
delimiter //
create trigger bin before insert on reservation for each row 
begin 
declare a,c int;
select avail,alloc into a,c from bus where bid=new.bid;
if(datediff(new.jdate1,new.rdate)<30) then
call reservation_closed();
elseif(a<new.nosa) then
call seats_insufficient();
else
set a=a-new.nosa;
set c=c+new.nosa;
update bus set avail=a,alloc=c where bid=new.bid;
end if;
end;
//

create trigger ain after insert on reservation for each row
begin
declare co int;
select cost into co from bus where bid=new.bid;
set co=co*new.nosa;
insert into ticket(bid,pid,source2,destination2,jdate2,nosa1,amount) values (new.bid,new.pid,new.source1,new.destination1,new.jdate1,new.nosa,co);
end;
//

delimiter ;

insert into reservation(bid,pid,jdate1,rdate,nosa,source1,destination1,status) values (10,1001,'2021-07-10','2021-06-08',4,'Hyderabad','Karimnagar','confirmed');


select * from bus;


select * from reservation;

                    
select * from ticket;


insert into reservation(bid,pid,jdate1,rdate,nosa,source1,destination1,status) values (12,1003,'2021-07-13','2021-06-03',6,'Hyderabad','Vizag','confirmed');


insert into reservation(bid,pid,jdate1,rdate,nosa,source1,destination1,status) values (13,1004,'2021-07-19','2021-06-17',2,'Hyderabad','Rajamundry','confirmed');


insert into reservation(bid,pid,jdate1,rdate,nosa,source1,destination1,status) values (11,1005,'2021-07-12','2021-06-08',5,'Hyderabad','Tirupathi','confirmed');


select * from reservation;


select * from ticket;


select * from bus;


#CANCELLATION

create table cancellation(
                         cid int auto_increment primary key,
                         bid int,pid int,tid int,cdate date,
                         nosc int,charge int,status1 varchar(30),
                         foreign key(bid) references bus(bid),
                         foreign key(pid) references passenger(pid),
                         foreign key(tid) references ticket(tid));
                         
delimiter //

create trigger din before insert on cancellation for each row
begin
declare a,c,na,na1,am,cos int;
select avail,alloc,cost into a,c,cos from bus where bid=new.bid;
select nosa into na from reservation where pid=new.pid;
select nosa1,amount into na1,am from ticket where tid=new.tid;
if(c<new.nosc) then
call invalid_cancel();
else
set a=a+new.nosc;
set c=c-new.nosc;
set na=na-new.nosc;
set na1=na1-new.nosc;
set am=am-new.nosc*cos;
update bus set avail=a,alloc=c where bid=new.bid;
update reservation set nosa=na where pid=new.pid;
update ticket set nosa1=na1,amount=am where tid=new.tid;
end if; 
end;
//

delimiter ;

insert into cancellation(bid,pid,tid,cdate,nosc,charge,status1) 
       values (10,1001,1,'2021-06-10',2,20,'Money Returned');

select * from cancellation;

select * from bus;

select * from reservation;

select * from ticket;
       
insert into cancellation(bid,pid,tid,cdate,nosc,charge,status1) 
	   values (12,1003,2,'2021-06-05',3,30,'Money Returned');   
       
select * from cancellation;

select * from bus;

select * from reservation;

select * from ticket;

#drop database roadwaytravels
