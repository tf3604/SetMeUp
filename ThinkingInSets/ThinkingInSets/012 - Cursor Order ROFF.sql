use CorpDB;
go

drop table if exists #Orders;

create table #Orders
(
	OrderId int not null,
	OrderDate datetime null,
	CustomerId int null
);

declare csr cursor read_only fast_forward
for
select oh.OrderId, oh.OrderDate, oh.CustomerId
from dbo.OrderHeader oh;

declare @OrderId int;
declare @OrderDate date;
declare @CustomerId int;

open csr;

fetch next from csr into @OrderId, @OrderDate, @CustomerId;
while @@fetch_status = 0
begin
	insert #Orders (OrderId, OrderDate, CustomerId)
	values (@OrderId, @OrderDate, @CustomerId);

	fetch next from csr into @OrderId, @OrderDate, @CustomerId;
end

close csr;
deallocate csr;
