use CorpDB;
go

drop function if exists dbo.GetLine1ProductId;
go
create function dbo.GetLine1ProductId (@OrderId int)
returns int
as
begin
	declare @ProductId int;

	select top 1 @ProductId = od.ProductId
	from dbo.OrderDetail od
	where od.OrderId = @OrderId;

	return @ProductId;
end
go

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	dbo.GetLine1ProductId(oh.OrderId) Line1ProductId
from dbo.OrderHeader oh
where oh.OrderDate >= '2016-01-01';
go
