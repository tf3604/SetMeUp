use CorpDB;
go

drop table if exists #OrderInfo;
go

create table #OrderInfo
(
	OrderId int not null,
	OrderDate datetime2 not null,
	CustomerId int not null,
	OrderLineNbr int not null,
	ProductId int not null,
	Quantity int not null,
	UnitPrice money not null,
	Amount money not null,
	RunningTotal money not null
);


declare csr cursor fast_forward read_only
for
select oh.OrderId, oh.OrderDate, oh.CustomerId,
	od.ProductId, od.Quantity, od.UnitPrice
from dbo.OrderHeader oh
inner join dbo.OrderDetail od on od.OrderId = oh.OrderId
inner join dbo.Customer c on c.CustomerID = oh.CustomerId
where c.State in ('CA', 'NY')
order by oh.OrderId, od.OrderDetailId;

declare @OrderId int;
declare @OrderDate datetime2;
declare @CustomerId int;
declare @OrderLineNbr int = 0;
declare @ProductId int;
declare @Quantity int;
declare @UnitPrice money;
declare @Amount money;
declare @RunningTotal money = 0.00;

open csr;

fetch next from csr into @OrderId, @OrderDate, @CustomerId, @ProductId, @Quantity, @UnitPrice;

while @@fetch_status = 0
begin
	select @OrderLineNbr += 1;
	select @Amount = @Quantity * @UnitPrice;
	select @RunningTotal += @Amount;

	insert #OrderInfo (OrderId, OrderDate, CustomerId, OrderLineNbr, ProductId, Quantity, UnitPrice, Amount, RunningTotal)
	values (@OrderId, @OrderDate, @CustomerId, @OrderLineNbr, @ProductId, @Quantity, @UnitPrice, @Amount, @RunningTotal);

	fetch next from csr into @OrderId, @OrderDate, @CustomerId, @ProductId, @Quantity, @UnitPrice;
end

close csr;
deallocate csr;

select *
from #OrderInfo
order by OrderId, OrderLineNbr;
