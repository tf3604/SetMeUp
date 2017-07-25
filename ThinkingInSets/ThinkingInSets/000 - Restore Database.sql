use master;
go

alter database CorpDB set offline with rollback immediate;
go

restore database CorpDB
from disk = 'c:\data\sql2016\backup\CorpDB.bak'
with replace;
go
