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
values('13198888701','���ǳ�','1','32','20220501');
insert 
into  Visitor
values('13198888702','��ܰ��','0','21','20220502');
insert 
into  Visitor
values('13198888703','����','1','18','20220503');
insert 
into  Visitor
values('13198888704','���л�','1','60','20220504');

----�������Ա����
insert 
into  Manager
values('101','123CUPer','����','1','60');
insert 
into  Manager
values('102','123CUPers','������','0','40');


--������Ա����
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
values('106','����','��������',True,False),
	  ('107','����','��������',True,True),
	  ('108','����','��������',True,True),
	  ('109','������','��������',False,False),
	  ('110','����','��������',True,True);

--�����������
insert
into Lake
values('101','����','1000','����·','120','1');
insert
into Lake
values('102','����','2000','�齭·','100','0');
insert
into Lake
values('103','�Ϻ�','3000','�ƺ�·','80','0');
insert
into Lake
values('104','����','1090','����·','190','1');

--�����·����
insert
into Road
values('101','2000','����','10');
('102','3000','����','10');
('103','2090','�齭','10');
('104','1800','ʯ��','10');

--�����������
insert
into Toilet
values('101','6','��һ��','0');
insert
into Toilet
values('102','8','������','1');
insert
into Toilet
values('103','4','��һ��','0');
insert
into Toilet
values('104','2','������','1');

--����ͣ��������
insert
into Parking
values('101','200','200','����·������','1');
insert
into Parking
values('102','100','400','����·������','0');
insert
into Parking
values('103','50','50','�ƺ�·������','1');
insert
into Parking
values('104','150','200','�齭·������','0');


--������������ԤԼ���
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

----�洢���̣���ѯԤԼ���
create procedure QuireBook 
as
select*from Book
execute QuireBook;

---�洢���̣�ԤԼ���޸���ԤԼ����������ԤԼ��������һ���贫�ݹ���ԤԼ����һ�죬���ԤԼ�������Ա���
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


--�洢���̣����ĳ��ӵ���������Ҫ���Ա�ύ��⵽������
create procedure SubmitNum @WormNum int,@TreeID char(3)
as
update Tree set InsectNum=@WormNum where TreeID=@TreeID
execute SubmitNum '10','101';
---�洢���̣�����ľ���漴�����ӵ�������Ϊ0����Ҫ���ݹ�����ľ��ID
create procedure Deworming @TreeID char(3)
as
update Tree set InsectNum='0' where TreeID=@TreeID
execute Deworming '101';
--�洢���̣��������г��ӵ���ľ������
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

--�洢���̣����Ա��⵽��ľ��Ҫ��ˮ������ľ��ˮ״̬��Ϊ0
create procedure Withered @TreeID char(3)
as
update Tree set Treewater='0' where TreeID=@TreeID
execute Withered '101';
--�洢���̣�����ľ��ˮ���贫�ݹ�����ľ��ID
create procedure Water @TreeID char(3)
as
update Tree set Treewater='1' where TreeID=@TreeID
execute Water '101';
--�洢���̣�������δ��ˮ����ľ��ˮ
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


--�洢���̣����Ա����⵽��ˮλ�ύ�����ݿ�
create procedure SubmitLevel @WaterLevel int,@LakeID char(3)
as
update Lake set WaterLevel=@WaterLevel where LakeID=@LakeID
execute SubmitLevel '100','101';
---�洢���̣����ˮλ����100cm����բ��
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


--�洢���̣��޲���·����Ҫ���ݵ�·��ID
create procedure FixRoad @RoadID char(3)
as
update Road set PotholesNum='0' where RoadID=@RoadID
execute FixRoad 101;
--�洢���̣�һ���޲����еĵ�·
create procedure FixAllRoad 
as
update Road set PotholesNum='0' 
execute FixAllRoad ;
--�洢���̣��鿴���в���Ŀǰ�������ɵ�����
create procedure QuireToilet
as
select ToiletID,PeopleNum,ToiletLoc from Toilet
execute QuireToilet;
--�洢���̣�ռ�ò���
create procedure UseToilet @ToiletID char(3)
as
update Toilet set PeopleNum=PeopleNum-1 where ToiletID=@ToiletID
execute UseToilet '101';
--�洢���̣�һ���������в���
create procedure CleanToilet 
as
update Toilet set ToiletClean='1'
execute CleanToilet;
--�洢���̣��鿴����ͣ����״̬
create procedure QuireParking
as
select*from Parking
execute QuireParking;

--�洢���̣�ռ��ͣ��������Ҫ����ͣ����ID
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