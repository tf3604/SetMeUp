drop procedure if exists usp_CreateNumsSet;
go

create procedure dbo.usp_CreateNumsSet (@max_num int)
with native_compilation, schemabinding, execute as owner
as
begin atomic with (transaction isolation level = snapshot, language = 'us_english')
	--insert dbo.NumsSets (n)
	--select n.n
	--from dbo.NumsLoops n;

	select l0.v, l1.v
	from (select 0 v union all select 1) l0
	cross join (select 0 v union all select 1) l1;
end
go

declare @loopNbr int = 0;
while @loopNbr < 5
begin
	delete dbo.NumsSets;
	declare @TestStartTime datetime2 = sysdatetime();

	exec dbo.usp_CreateNumsSet @max_num = 1000000;

	declare @TestEndTime datetime2 = sysdatetime();

	insert CorpDB.dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Hekaton Sets', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from CorpDB.dbo.ExecutionResult xr
	where xr.TestName = N'Hekaton Sets'
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
