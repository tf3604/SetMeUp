use CorpDB;
go

declare @loopNbr int = 0;
while @loopNbr < 5
begin
	declare @TestStartTime datetime2 = sysdatetime();

	drop table if exists #Customers;

	create table #Customers
	(
		CustomerID int not null,
		FirstName varchar(50) null,
		LastName varchar(50) null,
		Address varchar(50) null,
		City varchar(50) null,
		State varchar(50) null
	);

	declare csr cursor
	for
	select c.CustomerID, c.FirstName, c.LastName, c.Address, c.City, c.State
	from dbo.Customer c;

	declare @CustomerID int;
	declare @FirstName varchar(50);
	declare @LastName varchar(50);
	declare @Address varchar(50);
	declare @City varchar(50);
	declare @State varchar(50);

	open csr;

	fetch next from csr into @CustomerID, @FirstName, @LastName, @Address, @City, @State;
	while @@fetch_status = 0
	begin
		insert #Customers (CustomerID, FirstName, LastName, Address, City, State)
		values (@CustomerID, @FirstName, @LastName, @Address, @City, @State);

		fetch next from csr into @CustomerID, @FirstName, @LastName, @Address, @City, @State;
	end

	close csr;
	deallocate csr;
	declare @TestEndTime datetime2 = sysdatetime();

	insert dbo.ExecutionResult (TestName, StartTime, EndTime)
	values (N'Cursor - Customer', @TestStartTime, @TestEndTime);

	select @loopNbr += 1;
end
go

with MostRecentTestRun as
(
	select top 5 xr.ID, xr.TestName, xr.StartTime, xr.EndTime,
		   datediff(millisecond, xr.StartTime, xr.EndTime) RunTimeMs
	from dbo.ExecutionResult xr
	where xr.TestName = N'Cursor - Customer'
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
