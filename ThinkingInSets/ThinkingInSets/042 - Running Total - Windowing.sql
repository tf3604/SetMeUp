-----------------------------------------------------------------------------------------------------------------------
-- 042 - Running Total - Windowing.sql
-- Version 1.0.3
-- Look for the most recent version of this script at www.tf3604.com/sets.
-- MIT License.  See the bottom of this file for details.
-----------------------------------------------------------------------------------------------------------------------

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

-----------------------------------------------------------------------------------------------------------------------
-- Copyright 2017, Brian Hansen (brian at tf3604.com).

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
-----------------------------------------------------------------------------------------------------------------------

