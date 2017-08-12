drop procedure if exists usp_CreateNumsLoop;
go

create procedure dbo.usp_CreateNumsLoop (@max_num int)
with native_compilation, schemabinding, execute as owner
as
begin atomic with (transaction isolation level = snapshot, language = 'us_english')
    declare @counter int = 1;
    while @counter <= @max_num
    begin
        insert dbo.NumsLoops (n)
        values (@counter);
        select @counter = @counter + 1;
    end
end
go

declare @loopNbr int = 0;
while @loopNbr < 5
begin
	delete dbo.NumsLoops;
	declare @TestStartTime datetime2 = sysdatetime();

	exec dbo.usp_CreateNumsLoop @max_num = 1000000;

	declare @TestEndTime datetime2 = sysdatetime();

	insert CorpDB.dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Hekaton Loops', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from CorpDB.dbo.ExecutionResult xr
	where xr.TestName = N'Hekaton Loops'
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
