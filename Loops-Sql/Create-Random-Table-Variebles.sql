
--ad ve soyad ad�nda iki tablo olu�turulur ve fullname tablosuna random ad ve soyadlar eklenmeye �al���l�r
--
create table Ad(
Id int identity(1,1) primary key not null,
Ad nvarchar(30),
);

select*from ad

insert into ad values('max')
insert into ad values('ali')
insert into ad values('cem')
insert into ad values('su')
insert into ad values('asl�')
insert into ad values('noa')
insert into ad values('jane')

create table Soyad(
Id int identity(1,1) primary key not null,
Soyad nvarchar(30),
);

insert into Soyad values('as')
insert into Soyad values('kur')
insert into Soyad values('sos')
insert into Soyad values('ola')
insert into Soyad values('doe')
insert into Soyad values('kim')

select * from soyad

--random olarak fullname tablosuna isim ve soyisim g�nderilir

create table FullName(
Id int identity(1,1) not null primary key,
Ad nvarchar(15),
Soyad nvarchar(15),
DogumTarihi date,
Yas int,
YasGurubu nvarchar(20),
);

--de�i�kenler declare edilir
declare @i as int=0
declare @ad as nvarchar(15)
declare @soyad as nvarchar(15)
declare @dogumTarihi as date
declare @yas as int
declare @yasGurubu as nvarchar(20)
--while d�ng�s�nde �al��mas�n� istedi�imiz k�s�mlar se�ilir
while @i<10
begin
select @ad=ad from ad where Id=round(rand()*7,0)
select @soyad=soyad from soyad where Id=round(rand()*6,0)
select @dogumTarihi=dateadd(day,round(rand()*18250,0),'1950-01-01')
--365*50 50 y�l aras�nda se�im yap�lacak
select @yas=datediff(yy,@dogumTarihi,getdate())

if @yas between 18 and 35
	set @yasGurubu='genc'
if @yas between 35 and 45
	set @yasGurubu='orta yas'
if @yas between 46 and 80
	set @yasGurubu='ya�l�'
if @yas<18
	set @yasGurubu ='cocuk'

--fullname tablosuna olu�turdu�umuz verileri ekliyoruz
insert into FullName(ad,soyad,DogumTarihi,Yas,YasGurubu) values(@ad,@soyad,@dogumTarihi,@yas,@yasGurubu)
set @i+=1
end


select*from FullName
