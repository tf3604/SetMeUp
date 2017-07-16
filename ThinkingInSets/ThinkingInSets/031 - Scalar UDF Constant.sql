use CorpDB;
go

drop function if exists dbo.GetLine1ProductIdConst;
go
create function dbo.GetLine1ProductIdConst (@OrderId int)
returns int
as
begin
	declare @ProductId int;

	select @ProductId = 0;

	return @ProductId;
end
go

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	dbo.GetLine1ProductIdConst(oh.OrderId) Line1ProductId
from dbo.OrderHeader oh
where oh.OrderDate >= '2016-01-01';
go
