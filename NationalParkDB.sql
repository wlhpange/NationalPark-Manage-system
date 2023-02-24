use NPMSDB;
--drop table Visitor;
create table Visitor
(
Vtel char(11) primary key,
Vname char(20) not null,
Vsex bool not null,
Vage int not null,
Vtime char(8) not null
);


create table Manager
(
MID char(3) primary key,
MPW char(20) not null,
Mname char(20) not null,
Msex bool not null,
Mage int not null
);


create table Inspector
(
InspectorID char(3) primary key,
InspectorPW char(20)
);


create table Tree
(
TreeID char(3) primary key,
TreeSpe char(20),
TreeLoc char(20),
InsectNum int,
Treewater bool
);

create table Lake
(
LakeID char(3) primary key,
LakeName char(20),
LakeSize int,
LakeLoc char(20),
WaterLevel int,
GateState bool
);

--drop table Road;
create table Road
(
RoadID char(3) primary key,
RoadLength int,
RoadName char(20),
PotholesNum int
);

--drop table Toilet;
create table Toilet
(
ToiletID char(3) primary key,
PeopleNum int,
ToiletLoc char(20),
ToiletClean bool
);
--drop table Parking;
create table Parking
(
ParkingID char(3) primary key,
HaveNum int,
MaxNum int,
ParkingLoc char(20),
ParkingState bool
);


create table Book
(
TimeID char(4) primary key,
Booked int,
MaxNum int,
BookState bool
);

insert 
into  Visitor
values('13198888701','苏星楚','1','32','20220501');
insert 
into  Visitor
values('13198888702','乔馨宁','0','21','20220502');
insert 
into  Visitor
values('13198888703','米兰','1','18','20220503');
insert 
into  Visitor
values('13198888704','刘中华','1','60','20220504');

----插入管理员数据
insert 
into  Manager
values('101','123CUPer','商羽','1','60');
insert 
into  Manager
values('102','123CUPers','商羽沐','0','40');


--插入检测员数据
insert 
into  Inspector
values('101','123CUPers');
insert 
into  Inspector
values('102','123CUPers');
insert 
into  Inspector
values('103','123CUPers');
insert 
into  Inspector
values('104','123CUPers');


insert
into Tree
values('106','杨树','东南树林',True,False),
	  ('107','柳树','东北树林',True,True),
	  ('108','杨树','东南树林',True,True),
	  ('109','枇杷树','西南树林',False,False),
	  ('110','桃树','西北树林',True,True);

--插入湖泊数据
insert
into Lake
values('101','西湖','1000','长江路','120','1');
insert
into Lake
values('102','东湖','2000','珠江路','100','0');
insert
into Lake
values('103','南湖','3000','黄河路','80','0');
insert
into Lake
values('104','北湖','1090','淮河路','190','1');

--插入道路数据
insert
into Road
values('101','2000','淮河','10');
('102','3000','长江','10');
('103','2090','珠江','10');
('104','1800','石大','10');

--插入厕所数据
insert
into Toilet
values('101','6','东一区','0');
insert
into Toilet
values('102','8','东二区','1');
insert
into Toilet
values('103','4','西一区','0');
insert
into Toilet
values('104','2','西二区','1');

--插入停车场数据
insert
into Parking
values('101','200','200','长江路西二区','1');
insert
into Parking
values('102','100','400','长江路东二区','0');
insert
into Parking
values('103','50','50','黄河路西二区','1');
insert
into Parking
values('104','150','200','珠江路西二区','0');


--插入最近几天的预约情况
use NPMSDB
insert
into Book
values('0513',500,500,1);
insert
into Book
values('0514',298,500,0);
insert
into Book
values('0515',456,700,0);
insert
into Book
values('0516',218,500,0);

----存储过程，查询预约情况
create procedure QuireBook 
as
select*from Book
execute QuireBook;

---存储过程，预约后修改已预约的人数（以预约的人数加一）需传递过来预约的哪一天，如果预约已满可以报错
--drop procedure alterBook;
create procedure alterBook @date char(4)
as
declare @Booked int,@MaxNum int
declare cur1 cursor 	
for select Booked from BooK where TimeID=@date
open cur1
fetch next from cur1 into @Booked
declare cur2 cursor 	
for select MaxNum from BooK where TimeID=@date
open cur2
fetch next from cur2 into @MaxNum
begin
update Book set Booked=Booked+1 where TimeID=@date
end
close cur1
close cur2
deallocate cur1
deallocate cur2
execute alterBook '0513';


--存储过程，更改虫子的数量，需要检测员提交检测到的数据
create procedure SubmitNum @WormNum int,@TreeID char(3)
as
update Tree set InsectNum=@WormNum where TreeID=@TreeID
execute SubmitNum '10','101';
---存储过程，给树木除虫即将虫子的数量置为0，需要传递过来树木的ID
create procedure Deworming @TreeID char(3)
as
update Tree set InsectNum='0' where TreeID=@TreeID
execute Deworming '101';
--存储过程，给所有有虫子的树木都除虫
--drop procedure AllDeworming
create procedure AllDeworming 
as
declare @TreeID cursor
set @TreeID=cursor scroll dynamic 
for select TreeID from Tree
open @TreeID
declare @ID char(3)
declare @num int
fetch next from @TreeID into @ID
while(@@FETCH_STATUS=0)
    begin
	   select @num=(select InsectNum from Tree where TreeID=@ID)
	   if(@num!=0)
	     begin
	     update Tree set InsectNum='0' where TreeID=@ID
		 end
       fetch next from @TreeID into @ID
	end
close @TreeID
deallocate @TreeID
--update Tree set InsectNum='100' where TreeID='102';
execute AllDeworming;

--存储过程，检测员检测到树木需要浇水，将树木浇水状态置为0
create procedure Withered @TreeID char(3)
as
update Tree set Treewater='0' where TreeID=@TreeID
execute Withered '101';
--存储过程，给树木浇水，需传递过来树木的ID
create procedure Water @TreeID char(3)
as
update Tree set Treewater='1' where TreeID=@TreeID
execute Water '101';
--存储过程，给所有未浇水的树木浇水
create procedure AllWater
as
declare @TreeID cursor
set @TreeID=cursor scroll dynamic 
for select TreeID from Tree
open @TreeID
declare @ID char(3)
declare @water bit
fetch next from @TreeID into @ID
while(@@FETCH_STATUS=0)
    begin
	   select @water=(select Treewater from Tree where TreeID=@ID)
	   if(@water=0)
	     begin
	     update Tree set Treewater='1' where TreeID=@ID
		 end
       fetch next from @TreeID into @ID
	end
close @TreeID
deallocate @TreeID
execute AllWater;


--存储过程，检测员将检测到的水位提交给数据库
create procedure SubmitLevel @WaterLevel int,@LakeID char(3)
as
update Lake set WaterLevel=@WaterLevel where LakeID=@LakeID
execute SubmitLevel '100','101';
---存储过程，如果水位大于100cm开放闸门
--drop procedure opengate
create procedure opengate
as
declare @LakeID cursor
set @LakeID=cursor scroll dynamic 
for select LakeID from Lake
open @LakeID
declare @ID char(3)
declare @Waterlevel int
fetch next from @LakeID into @ID
while(@@FETCH_STATUS=0)
    begin
	   select @Waterlevel=(select WaterLevel from Lake where LakeID=@ID)
	   if(@Waterlevel>=100)
	     begin
	     update Lake set GateState='1' where LakeID=@ID
		 end
       fetch next from @LakeID into @ID
	end
close @LakeID
deallocate @LakeID
execute opengate;


--存储过程，修补道路，需要传递道路的ID
create procedure FixRoad @RoadID char(3)
as
update Road set PotholesNum='0' where RoadID=@RoadID
execute FixRoad 101;
--存储过程，一键修补所有的道路
create procedure FixAllRoad 
as
update Road set PotholesNum='0' 
execute FixAllRoad ;
--存储过程，查看所有厕所目前可以容纳的人数
create procedure QuireToilet
as
select ToiletID,PeopleNum,ToiletLoc from Toilet
execute QuireToilet;
--存储过程，占用厕所
create procedure UseToilet @ToiletID char(3)
as
update Toilet set PeopleNum=PeopleNum-1 where ToiletID=@ToiletID
execute UseToilet '101';
--存储过程，一键清理所有厕所
create procedure CleanToilet 
as
update Toilet set ToiletClean='1'
execute CleanToilet;
--存储过程，查看所有停车场状态
create procedure QuireParking
as
select*from Parking
execute QuireParking;

--存储过程，占用停车场，需要传递停车场ID
--drop procedure UseParking
create procedure UseParking @ParkingID char(3)
as
declare @HaveNum int,@MaxNum int
set @HaveNum=(select HaveNum from Parking where ParkingID=@ParkingID)
set @MaxNum=(select MaxNum from Parking where ParkingID=@ParkingID)
if(@HaveNum=@MaxNum-1)
begin
update Parking set HaveNum=HaveNum+1 where ParkingID=@ParkingID
update Parking set ParkingState='1' where ParkingID=@ParkingID
end
else
update Parking set HaveNum=HaveNum+1 where ParkingID=@ParkingID

execute UseParking '102';
--