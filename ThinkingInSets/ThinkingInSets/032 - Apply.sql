use CorpDB;
go

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	prod.Line1ProductId
from dbo.OrderHeader oh
outer apply
(
	select top 1 od.ProductId Line1ProductId
	from dbo.OrderDetail od
	where od.OrderId = oh.OrderId
) prod
where oh.OrderDate >= '2016-01-01';
go
