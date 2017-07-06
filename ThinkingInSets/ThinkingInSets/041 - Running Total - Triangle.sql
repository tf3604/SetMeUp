use CorpDB;
go

drop table if exists #OrderInfo;
go

create table #OrderInfo
(
	OrderId int not null,
	OrderDate datetime not null,
	CustomerId int not null,
	OrderLineNbr int not null,
	ProductId int not null,
	Quantity int not null,
	UnitPrice money not null,
	Amount money not null,
	RunningTotal money not null
);
go

insert #OrderInfo (OrderId, OrderDate, CustomerId, OrderLineNbr, ProductId, Quantity, UnitPrice, Amount, RunningTotal)
select oh.OrderId, oh.OrderDate, oh.CustomerId, rtinfo.OrderLineNbr,
	od1.ProductId, od1.Quantity, od1.UnitPrice, od1.Quantity * od1.UnitPrice Amount,
	rtinfo.RunningTotal
from dbo.OrderHeader oh
inner join dbo.OrderDetail od1 on od1.OrderId = oh.OrderId
outer apply
(
	select od2.OrderId, count(*) OrderLineNbr, sum(od2.Quantity * od2.UnitPrice) RunningTotal
	from dbo.OrderDetail od2
	where od2.OrderId = oh.OrderId
	and od2.OrderDetailId <= od1.OrderDetailId
	group by od2.OrderId
) rtinfo
order by oh.OrderId, od1.OrderDetailId;


select oh.OrderId, oh.OrderDate, oh.CustomerId,
	(
		select count(*)
		from dbo.OrderDetail od2
		where od2.OrderId = oh.OrderId
		and od2.OrderDetailId <= od1.OrderDetailId
	) OrderLineNbr,
	od1.ProductId, od1.Quantity, od1.UnitPrice, od1.Quantity * od1.UnitPrice Amount,
	(
		select sum(od2.Quantity * od2.UnitPrice)
		from dbo.OrderDetail od2
		where od2.OrderId = oh.OrderId
		and od2.OrderDetailId <= od1.OrderDetailId
	)
from dbo.OrderHeader oh
inner join dbo.OrderDetail od1 on od1.OrderId = oh.OrderId
order by oh.OrderId, od1.OrderDetailId;


select oh.OrderId, oh.OrderDate, oh.CustomerId,
	(
		select count(*)
		from dbo.OrderDetail od2
		where od2.OrderDetailId <= od1.OrderDetailId
	) OrderLineNbr,
	od1.ProductId, od1.Quantity, od1.UnitPrice, od1.Quantity * od1.UnitPrice Amount,
	(
		select sum(od2.Quantity * od2.UnitPrice)
		from dbo.OrderDetail od2
		where od2.OrderDetailId <= od1.OrderDetailId
	)
from dbo.OrderHeader oh
inner join dbo.OrderDetail od1 on od1.OrderId = oh.OrderId
inner join dbo.Customer c on c.CustomerID = oh.CustomerId
where c.State in ('CA', 'NY')
order by oh.OrderId, od1.OrderDetailId;
