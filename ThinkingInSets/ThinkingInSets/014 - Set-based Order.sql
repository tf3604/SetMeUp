use CorpDB;
go

drop table if exists #Orders;

create table #Orders
(
	OrderId int not null,
	OrderDate datetime null,
	CustomerId int null
);

insert #Orders (OrderId, OrderDate, CustomerId)
select OrderId, OrderDate, CustomerId
from dbo.OrderHeader;
