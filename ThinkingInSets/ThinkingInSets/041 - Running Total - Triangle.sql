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
		) RunningTotal
	from dbo.OrderHeader oh
	inner join dbo.OrderDetail od1 on od1.OrderId = oh.OrderId
	inner join dbo.Customer c on c.CustomerID = oh.CustomerId
	where c.State in ('CA', 'NY')
	order by oh.OrderId, od1.OrderDetailId;

	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Running Total - Triangle', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'Running Total - Triangle'
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
