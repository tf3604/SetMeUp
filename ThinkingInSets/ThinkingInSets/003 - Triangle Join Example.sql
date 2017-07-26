use tempdb;
go

create table dbo.PersonDim
(
	ID int not null identity(1,1) primary key clustered,
	CustomerId int not null,
	CustomerStatus nvarchar(50) not null,
	Comment nvarchar(200) not null,
	ValidFrom date not null,
	ValidTo date not null
);

insert dbo.PersonDim
(
    CustomerId,
    CustomerStatus,
	Comment,
    ValidFrom,
    ValidTo
)
values (12345, 'None', 'Acquired via Purchased List', '2017-01-03', '2017-03-02'), (12345, 'Contact', 'Contacted via outbound call', '2017-03-02', '2017-04-07'),
	(12345, 'Prospect', 'Requested info via website', '2017-04-07', '2017-06-06'), (12345, 'Customer', 'Purchased product via inbound call', '2017-06-06', '9999-12-31');

select ID, ID, CustomerId, CustomerStatus, Comment, ValidFrom, ValidTo
from dbo.PersonDim
order by ValidFrom;


select *
from dbo.PersonDim pd
where pd.CustomerStatus = 'Contact'
and
(
	select top 1 pnext.CustomerStatus
	from dbo.PersonDim pnext
	where pnext.CustomerId = pd.CustomerId
	and pnext.ValidFrom > pd.ValidFrom
	order by pnext.ValidFrom
) = 'Prospect';
