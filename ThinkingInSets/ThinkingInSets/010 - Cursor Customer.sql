use CorpDB;
go

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
