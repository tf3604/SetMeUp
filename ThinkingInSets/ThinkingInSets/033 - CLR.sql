--exec sp_configure 'clr enabled', 1;
--reconfigure;
--go



select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	dbo.ConstantFunc() Zero
from dbo.OrderHeader oh
where oh.OrderDate >= '2016-01-01';
go

select oh.OrderId,
	oh.OrderDate,
	oh.CustomerId,
	dbo.DataAccessFunc(oh.OrderId) Line1ProductId
from dbo.OrderHeader oh
where oh.OrderDate >= '2016-01-01';
go
