use CorpDB;
go

drop table if exists #Orders;

create table #Orders
(
	OrderId int not null,
	OrderDate datetime null,
	CustomerId int null
);

declare @minOrderId int = (select min(OrderId) from dbo.OrderHeader);
declare @maxOrderId int = (select max(OrderId) from dbo.OrderHeader);

declare @OrderId int = @minOrderId;
declare @OrderDate date;
declare @CustomerId int;

while @OrderId <= @maxOrderId
begin
	select @OrderDate = oh.OrderDate, @CustomerId = oh.CustomerId
	from dbo.OrderHeader oh
	where oh.OrderId = @OrderId;

	insert #Orders (OrderId, OrderDate, CustomerId)
	values (@OrderId, @OrderDate, @CustomerId);

	select @OrderId += 1;
end
