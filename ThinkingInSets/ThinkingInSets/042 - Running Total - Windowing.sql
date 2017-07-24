use CorpDB;
go

declare @loopNbr int = 0;
while @loopNbr < 5
begin
	declare @TestStartTime datetime2 = sysdatetime();

	drop table if exists #OrderInfo;

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

	insert #OrderInfo (OrderId, OrderDate, CustomerId, OrderLineNbr, ProductId, Quantity, UnitPrice, Amount, RunningTotal)
	select oh.OrderId, oh.OrderDate, oh.CustomerId,
		row_number() over (order by oh.OrderId, od.OrderDetailId) OrderLineNbr,
		od.ProductId, od.Quantity, od.UnitPrice, od.Quantity * od.UnitPrice Amount,
		sum(od.Quantity * od.UnitPrice) over (order by oh.OrderId, od.OrderDetailId rows unbounded preceding) RunningTotal
	from dbo.OrderHeader oh
	inner join dbo.OrderDetail od on od.OrderId = oh.OrderId
	inner join dbo.Customer c on c.CustomerID = oh.CustomerId
	where c.State in ('CA', 'NY')
	order by oh.OrderId, od.OrderDetailId;

	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Running Total - Windowing', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'Running Total - Windowing'
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
