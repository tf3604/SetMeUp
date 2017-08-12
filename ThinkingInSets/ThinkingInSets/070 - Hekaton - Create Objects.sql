use master;
go
--alter database InMemoryDb set offline with rollback immediate;
--alter database InMemoryDb set online with rollback immediate;

drop database if exists InMemoryDb;

create database InMemoryDB
on primary (name = 'InMemoryDb', filename = 'c:\data\sql2016\data\InMemoryDb.mdf'),
filegroup InMemoryDbFG contains memory_optimized_data
(name = InMemoryDbFS, filename = 'c:\data\sql2016\data\InMemoryDbFS1'),
(name = InMemroyDbFS, filename = 'c:\data\sql2016\data\InMemoryDbFS2')
log on (name = 'InMemoryDb_log', filename = 'c:\data\sql2016\log\InMemoryDb_log.ldf');
go

alter database InMemoryDB set memory_optimized_elevate_to_snapshot on;
go

use InMemoryDb;
go

drop table if exists dbo.NumsLoops;

create table dbo.NumsLoops
(
	n int not null,
	primary key nonclustered hash (n) with (bucket_count = 1048576)
) with (memory_optimized = on, durability = schema_and_data);

drop table if exists dbo.NumsSets;

create table dbo.NumsSets
(
	n int not null,
	primary key nonclustered hash (n) with (bucket_count = 1048576)
) with (memory_optimized = on, durability = schema_and_data);

