use CorpDB;
go

declare @loopNbr int = 0;
while @loopNbr < 5
begin
	declare @TestStartTime datetime2 = sysdatetime();

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

	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Cursor - Order ROFF', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'Cursor - Order ROFF'
	order by xr.StartTime desc
), MiddleRuns as
(
	select xr.ID, xr.TestName, xr.StartTime, xr.EndTime, xr.RunTimeMs
	from MostRecentTestRun xr
	order by xr.RunTimeMs
	offset 1 row fetch next 3 rows only
)
select ID, TestName, StartTime, EndTime, RunTimeMs,
	(select avg(RunTimeMs) from MiddleRuns) AvgRunTimeMs
from MiddleRuns;
