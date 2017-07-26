use CorpDB;
go

declare @loopNbr int = 0;
while @loopNbr < 5
begin
	declare @TestStartTime datetime2 = sysdatetime();

	drop table if exists #Line1ProductId;

	create table #Line1ProductId
	(
		OrderId int not null,
		Line1ProductId int null
	);

	insert #Line1ProductId (OrderId, Line1ProductId)
	select od.OrderId, od.ProductId
	from dbo.OrderDetail od
	inner join
	(
		select odm.OrderId, min(odm.OrderDetailId) MinOrderDetailId
		from dbo.OrderDetail odm
		group by odm.OrderId
	) odm on odm.MinOrderDetailId = od.OrderDetailId
	
	create clustered index clidx_Line1ProductId on #Line1ProductId (OrderId);

	drop table if exists #Orders;

	create table #Orders
	(
		OrderId int not null,
		OrderDate datetime null,
		CustomerId int null,
		Line1ProductId int null
	);

	insert #Orders (OrderId, OrderDate, CustomerId, Line1ProductId)
	select oh.OrderId,
		oh.OrderDate,
		oh.CustomerId,
		prod.Line1ProductId
	from dbo.OrderHeader oh
	left join #Line1ProductId prod on prod.OrderId = oh.OrderId;

	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Subquery in Select - Rewrite using temp table', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'Subquery in Select - Rewrite using temp table'
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
