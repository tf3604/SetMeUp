restore database CorpDB
from disk = 'c:\data\sql2016\backup\CorpDB.bak'
with replace;


go

use CorpDB;

create table ExecutionResult
(
	ID int not null identity(1,1),
	TestName nvarchar(75) not null,
	StartTime datetime2 not null,
	EndTime datetime2 not null,
	constraint pk_ExecutionResult primary key clustered (ID)
);
