use CorpDB;
go

select oh.OrderId, oh.OrderDate, oh.CustomerId,
	row_number() over (order by oh.OrderId, od.OrderDetailId) OrderLineNbr,
	od.ProductId, od.Quantity, od.UnitPrice, od.Quantity * od.UnitPrice Amount,
	sum(od.Quantity * od.UnitPrice) over (order by oh.OrderId, od.OrderDetailId rows unbounded preceding) RunningTotal
from dbo.OrderHeader oh
inner join dbo.OrderDetail od on od.OrderId = oh.OrderId
inner join dbo.Customer c on c.CustomerID = oh.CustomerId
where c.State in ('CA', 'NY')
order by oh.OrderId, od.OrderDetailId;
