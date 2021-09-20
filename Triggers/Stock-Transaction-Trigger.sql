

create database TRGExample

use trgexample

create table Items(
ItemId int identity(1,1) not null primary key,
ItemCode varchar(10),
ItemName varchar(50)
);

--seeding
insert into Items (ItemCode,ItemName) values('urun003','urun3')

create table ItemTransactions(
TrId int identity(1,1) not null primary key,
ItemId int,
Date_ datetime,
Amount int,
IOtype smallint
);

--seeding
declare @i as int=0
while @i<100000
begin

declare @ItemId as int
declare @date as datetime
declare @amount as int 
declare @IOtype as smallint

set @ItemId=round(rand()*3,0)--tablodaki 3 kay�ttan birini se�
	if @ItemId=0
		set @ItemId=1--0-3 aras� se�er ;0 gelme durumu i�in

set @date=dateadd(day,-round(rand()*365,0),getdate())
set @amount=round(rand()*9,0)+1--1-10 aras� amount se�er
set @IOtype=round(rand()*1,0)+1

		insert into ItemTransactions(ItemId,Date_,Amount,IOtype)
		values(@ItemId,@date,@amount,@IOtype)
		set @i=@i+1
end

--idsi 1 olan �r�n�n yapt��� giri� ve ��k��lar ve miktar�
select IOtype,sum(Amount) amount,COUNT(IOtype) totalIO from ItemTransactions
where ItemId=1
group by IOtype


--sub query ile her bir �r�n�n giri� ile ��k�� �r�n say�s�n�n fark�n� ald�k
set statistics io on
select *,
(select sum(amount) from ItemTransactions
where ItemId=it.ItemId and IOtype=1)
-
(select sum(amount) from ItemTransactions
where ItemId=it.ItemId and IOtype=2) as stock
from Items it
--bu �ekilde yapt���m�z sorgu 1712 sayfa ar�yor
--stok bilgisini ba�ka tabloda tutmak daha performansl� olur

create table Stock(
StockId int primary key not null identity(1,1),
ItemId int,
Stock int
);

set statistics io on
select * from Stock
--ayr� tabloya al�n�nca sadece 2 page okuyor


--itemtransaction tablosunu truncate edip stoklar� da 0 layal�m ki senaryoyu g�relim
truncate table ItemTransactions

update stock set stock=0

create trigger trg_transactionInsert
on ItemTransactions
after insert
as
begin

declare @ItemId as int
declare @amount as int
declare @IOtype as smallint
select @ItemId=ItemId,@amount=Amount,@IOtype=IOtype from inserted
	if @IOtype=1
		update stock set Stock +=@amount where ItemId=@ItemId
	if @IOtype=2
		update stock set Stock=Stock-@amount where ItemId=@ItemId

end

--tablonun �nce bo� oldu�undan emin olal�m
select * from Stock where ItemId=1
select * from ItemTransactions

insert into ItemTransactions (ItemId,Amount,Date_,IOtype)
values(1,5,getdate(),1)--5 kay�t girelim

insert into ItemTransactions (ItemId,Amount,Date_,IOtype)
values(1,20,getdate(),1)--20 kay�t girelim

insert into ItemTransactions (ItemId,Amount,Date_,IOtype)
values(1,10,getdate(),2)--10 kay�t silelim

select * from Stock where ItemId=1
select * from ItemTransactions
--ItemTransactions tablosuna veri giri� ��k��� olunca ayn� anda stok tablosunun bilgileri g�ncelleniyor


-- miktar� g�ncellemek i�in tetikleyici olu�turun
create trigger trg_transactionInsert_update
on ItemTransactions
after update
as
begin

declare @ItemId as int
declare @IOtype as smallint
declare @oldamount as int
declare @newamount as int
declare @amount as int

select @ItemId=ItemId,@oldamount=Amount,@IOtype=IOtype from deleted

select @newamount=amount from inserted

select @amount=@oldamount-@newamount

if @IOtype=1
	update stock set Stock -=@amount where ItemId=@ItemId
if @IOtype=2
	update stock set Stock=Stock+@amount where ItemId=@ItemId
end

--normalde 5 giri� yapm�� olan bu kay�t 2 ile g�ncellenince aradaki fark kadar stok d���rd�
update ItemTransactions set amount=2 where TrId=1