use CorpDB;
go

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	(
		select top 1 od.ProductId
		from dbo.OrderDetail od
		where od.OrderId = oh.OrderId
	) Line1ProductId
from dbo.OrderHeader oh;


select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	od.ProductId Line1ProductId
from dbo.OrderHeader oh
outer apply
(
	select top 1 od.ProductId
	from dbo.OrderDetail od
	where od.OrderId = oh.OrderId
) od;


select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId
from dbo.OrderHeader oh
where
(
	select top 1 od.ProductId
	from dbo.OrderDetail od
	where od.OrderId = oh.OrderId
) = 4926;

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId
from dbo.OrderHeader oh
outer apply
(
	select top 1 od.ProductId
	from dbo.OrderDetail od
	where od.OrderId = oh.OrderId
) od
where od.ProductId = 4926;
