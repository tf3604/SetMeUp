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
		CustomerId int null,
		Line1ProductId int null
	);

	with ProductIdWithLineNbr as
	(
		select od.ProductId,
			od.OrderId,
			row_number() over (partition by od.OrderId order by od.OrderDetailId) LineNbr
		from dbo.OrderDetail od
	)
	insert #Orders (OrderId, OrderDate, CustomerId, Line1ProductId)
	select oh.OrderId,
		oh.OrderDate,
		oh.CustomerId,
		pwl.ProductId Line1ProductId
	from dbo.OrderHeader oh
	inner join ProductIdWithLineNbr pwl on oh.OrderId = pwl.OrderId
	where pwl.LineNbr = 1;

	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Subquery in Select - Rewrite as RowNum', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'Subquery in Select - Rewrite as RowNum'
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
