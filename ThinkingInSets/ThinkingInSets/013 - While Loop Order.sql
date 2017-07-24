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

	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'While Loop - Order', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'While Loop - Order'
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
