use CorpDB;
go

drop function if exists dbo.GetLine1ProductIdTVF
go

create function dbo.GetLine1ProductIdTVF (@OrderId int)
returns table
as
return
select top 1 od.ProductId
from dbo.OrderDetail od
where od.OrderId = @OrderId;
go

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	od.ProductId Line1ProductId
from dbo.OrderHeader oh
outer apply dbo.GetLine1ProductIdTVF (oh.OrderId) od
where oh.OrderDate >= '2016-01-01';
go
