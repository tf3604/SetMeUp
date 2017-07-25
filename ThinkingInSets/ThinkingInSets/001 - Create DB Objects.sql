use CorpDB;
go

create table dbo.ExecutionResult
(
	ID int not null identity(1,1),
	TestName nvarchar(75) not null,
	StartTime datetime2 not null,
	EndTime datetime2 null,
	constraint pk_ExecutionResult primary key clustered (ID)
);
go

if not exists (select * from sys.schemas s where s.name = 'stage')
begin
	declare @sql nvarchar(max) = 'create schema stage authorization dbo;';
	exec(@sql);
end
go

drop table if exists stage.DataFile

create table stage.DataFile
(
	DataFileId int not null identity(1,1),
	FilePath nvarchar(260) not null,
	LastWriteTime datetime2 null,
	constraint pk_DataFile primary key clustered (DataFileId)
);
go

exec sp_configure 'clr enabled', 1;
reconfigure;

GO
PRINT N'Creating [ClrFunctionPerformance]...';


GO
CREATE ASSEMBLY [ClrFunctionPerformance]
    AUTHORIZATION [dbo]
    FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000800000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000504500004C010300037C76590000000000000000E00002210B010B00000A00000006000000000000FE280000002000000040000000000010002000000002000004000000000000000600000000000000008000000002000000000000030060850000100000100000000010000010000000000000100000000000000000000000A42800005700000000400000E002000000000000000000000000000000000000006000000C0000006C2700001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000080000000000000000000000082000004800000000000000000000002E746578740000000409000000200000000A000000020000000000000000000000000000200000602E72737263000000E00200000040000000040000000C0000000000000000000000000000400000402E72656C6F6300000C0000000060000000020000001000000000000000000000000000004000004200000000000000000000000000000000E02800000000000048000000020005000C21000060060000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013300100070000000100001100160A2B00062A001B3003007800000002000011007201000070730500000A0A00066F0600000A0072310000700B0706730700000A0C00086F0800000A72F8000070028C0B000001730900000A6F0A00000A26086F0B00000AA50B0000010D091304DE240814FE01130511052D07086F0C00000A00DC0614FE01130511052D07066F0C00000A00DC0011042A011C0000020022002E5000120000000002000C0056620012000000001E02280D00000A2A42534A4201000100000000000C00000076342E302E33303331390000000005006C0000009C010000237E0000080200002002000023537472696E677300000000280400000C0100002355530034050000100000002347554944000000440500001C01000023426C6F620000000000000002000001471502000900000000FA253300160000010000000E0000000200000003000000010000000D0000000500000002000000010000000200000000000A0001000000000006004A00430006008E007B000B00A20000000600D100B1000600F100B1000A004D0132010A00780162010A00990186010A00AB0162010A00B60162010600DC0143000A00E20162010A00F301860106000B02430000000000010000000000010001000100100025000000050001000100502000000000960051000A00010064200000000096005E000E00010004210000000086186D001300020000000100730011006D00170021006D001D0029006D00130031006D00130039006D00BC004100A601130049006D00C1004900CD01C80061006D00CD005100EF01D3006900FD01DA0071001702130009006D0013002000230022002E000B00E9002E001300F2002E001B00FB00400023002B002700DE000480000000000000000000000000000000000F01000004000000000000000000000001003A0000000000040000000000000000000000010026010000000000000000003C4D6F64756C653E00436C7246756E6374696F6E506572666F726D616E63652E646C6C0055736572446566696E656446756E6374696F6E73006D73636F726C69620053797374656D004F626A65637400436F6E7374616E7446756E63004461746141636365737346756E63002E63746F72006F7264657249640053797374656D2E446961676E6F73746963730044656275676761626C6541747472696275746500446562756767696E674D6F6465730053797374656D2E52756E74696D652E436F6D70696C6572536572766963657300436F6D70696C6174696F6E52656C61786174696F6E734174747269627574650052756E74696D65436F6D7061746962696C69747941747472696275746500436C7246756E6374696F6E506572666F726D616E63650053797374656D2E44617461004D6963726F736F66742E53716C5365727665722E5365727665720053716C46756E6374696F6E4174747269627574650053797374656D2E446174612E53716C436C69656E740053716C436F6E6E656374696F6E0053797374656D2E446174612E436F6D6D6F6E004462436F6E6E656374696F6E004F70656E0053716C436F6D6D616E640053716C506172616D65746572436F6C6C656374696F6E006765745F506172616D657465727300496E7433320053716C506172616D6574657200416464004462436F6D6D616E6400457865637574655363616C61720049446973706F7361626C6500446973706F73650000002F63006F006E007400650078007400200063006F006E006E0065006300740069006F006E003D0074007200750065000080C5730065006C00650063007400200074006F007000200031002000500072006F006400750063007400490064002000660072006F006D002000640062006F002E004F007200640065007200440065007400610069006C0020006F00640020007700680065007200650020006F0064002E004F0072006400650072004900640020003D00200040004F0072006400650072004900640020006F00720064006500720020006200790020004F007200640065007200440065007400610069006C00490064003B00001140004F00720064006500720049006400000000AC908646D7D24E47B6A4A5A4A3D09FA00008B77A5C561934E0890300000804000108080320000105200101110D0420010108040100000003070108808F010001005455794D6963726F736F66742E53716C5365727665722E5365727665722E446174614163636573734B696E642C2053797374656D2E446174612C2056657273696F6E3D342E302E302E302C2043756C747572653D6E65757472616C2C205075626C69634B6579546F6B656E3D623737613563353631393334653038390A4461746141636365737301000000042001010E062002010E121D0420001229052002010E1C062001123112310320001C0A0706121D0E12250808020801000701000000000801000800000000001E01000100540216577261704E6F6E457863657074696F6E5468726F777301000000000000037C765900000000020000001C01000088270000880900005253445304592E73B7C3BF479AEE04CC022CA88103000000633A5C646174615C5265706F735C5365744D6555705C436C7246756E6374696F6E506572666F726D616E63655C436C7246756E6374696F6E506572666F726D616E63655C6F626A5C44656275675C436C7246756E6374696F6E506572666F726D616E63652E706462000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000CC2800000000000000000000EE280000002000000000000000000000000000000000000000000000E02800000000000000000000000000000000000000005F436F72446C6C4D61696E006D73636F7265652E646C6C0000000000FF250020001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100100000001800008000000000000000000000000000000100010000003000008000000000000000000000000000000100000000004800000058400000840200000000000000000000840234000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE00000100000000000000000000000000000000003F000000000000000400000002000000000000000000000000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000000B004E4010000010053007400720069006E006700460069006C00650049006E0066006F000000C001000001003000300030003000300034006200300000002C0002000100460069006C0065004400650073006300720069007000740069006F006E000000000020000000300008000100460069006C006500560065007200730069006F006E000000000030002E0030002E0030002E003000000058001B00010049006E007400650072006E0061006C004E0061006D006500000043006C007200460075006E006300740069006F006E0050006500720066006F0072006D0061006E00630065002E0064006C006C00000000002800020001004C006500670061006C0043006F00700079007200690067006800740000002000000060001B0001004F0072006900670069006E0061006C00460069006C0065006E0061006D006500000043006C007200460075006E006300740069006F006E0050006500720066006F0072006D0061006E00630065002E0064006C006C0000000000340008000100500072006F006400750063007400560065007200730069006F006E00000030002E0030002E0030002E003000000038000800010041007300730065006D0062006C0079002000560065007200730069006F006E00000030002E0030002E0030002E003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000C000000003900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;


GO
ALTER ASSEMBLY [ClrFunctionPerformance]
    DROP FILE ALL
    ADD FILE FROM 0x4D6963726F736F667420432F432B2B204D534620372E30300D0A1A445300000000020000020000001B00000084000000000000001800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020F9E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF080618FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0BCA3101380000000010000000100000000000000E00FFFF04000000FFFF0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F862513FC607D311905300C04FA302A1C4454B99E9E6D211903F00C04FA302A10B9D865A1166D311BD2A0000F80849BD60A66E40CF64824CB6F042D48172A79910000000000000002BC48DAAC2318962FAC4D0C43809764608000000090000000C0000000D0000000E0000000F00000011000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F862513FC607D311905300C04FA302A1C4454B99E9E6D211903F00C04FA302A10B9D865A1166D311BD2A0000F80849BD60A66E40CF64824CB6F042D48172A79910000000000000000FF54D70A50746D89C7330F9E632AD46000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000BCA310138000000001000000010000000000000FFFFFFFF04000000FFFF030000000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000BCA310138000000001000000010000000000000FFFFFFFF04000000FFFF030000000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007F000000000000007F0000000000000000000000000000000000000000000000F0030000440200002C0000006C000000FFFFFFFF2800000016000000030000000600000012000000070000000A00000009000000040000000C0000000D0000000E0000000F000000110000001000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000BCA3101380000000010000000100000000000001000FFFF04000000FFFF0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FEEFFEEF01000000A600000000633A5C646174615C6465765C546573745C436C7246756E6374696F6E506572666F726D616E63655C436C7246756E6374696F6E506572666F726D616E63655C5363616C617246756E6374696F6E732E63730000633A5C646174615C6465765C746573745C636C7266756E6374696F6E706572666F726D616E63655C636C7266756E6374696F6E706572666F726D616E63655C7363616C617266756E6374696F6E732E637300040000005300000000000000010000005400000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001BE23001AC00000067F12E9FD004D301030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000400000001000000030000000000000054000000280000001BE2300174105BBF58000000010000005300000054000000650000000000000000000000FD000000280000001BE23001BB4D4DA058000000A600000053000000FD0000006500000000000000000000006E732E63730004000000530000000000000001000000540000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FEEFFEEF010000005401000000633A5C646174615C6465765C546573745C436C7246756E6374696F6E506572666F726D616E63655C436C7246756E6374696F6E506572666F726D616E63655C5363616C617246756E6374696F6E732E63730000633A5C646174615C6465765C746573745C636C7266756E6374696F6E706572666F726D616E63655C636C7266756E6374696F6E706572666F726D616E63655C7363616C617266756E6374696F6E732E637300633A5C646174615C5265706F735C5365744D6555705C436C7246756E6374696F6E506572666F726D616E63655C436C7246756E6374696F6E506572666F726D616E63655C5363616C617246756E6374696F6E732E637300633A5C646174615C7265706F735C7365746D6575705C636C7266756E6374696F6E706572666F726D616E63655C636C7266756E6374696F6E706572666F726D616E63655C7363616C617266756E6374696F6E732E637300070000000000000053000000A6000000FD00000000000000010000005400000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000036002A1100000000200100000000000007000000000000000000000001000006000000000100000000436F6E7374616E7446756E630000001600031104000000EC0000000700000000000000010000000A0024115553797374656D00120024115553797374656D2E44617461000000001A0024115553797374656D2E446174612E53716C436C69656E7400001A0024115553797374656D2E446174612E53716C54797065730000001E002411554D6963726F736F66742E53716C5365727665722E536572766572001E00201100000000010000110000000000000400435324312430303030000000020006002E000404C93FEAC6B359D649BC250902BBABB460000000004D0044003200000004010000040000000C000000010005000200060036002A1100000000C802000000000000780000000000000000000000020000060700000001000000004461746141636365737346756E63001600031124010000940200007800000007000000010000001E002011040000000200001100000000000004004353243124303030300000001E00201105000000020000110000000000000400435324342430303031000000160003115C010000900200007300000008000000010000001E00201100000000020000110000000000000000636F6E6E656374696F6E000016000311B40100008C020000560000001300000001000000160020110100000002000011000000000000000073716C0016000311EC010000880200004800000021000000010000001A00201102000000020000110000000000000000636F6D6D616E6400160003111C020000840200002E00000029000000010000001A00201103000000020000110000000000000000636F756E7400000002000600020006000200060002000600020006002E000404C93FEAC6B359D649BC250902BBABB460000000004D0044003200000004010000040100000C0000000100000602000600F20000003C000000000000000100010007000000000000000300000030000000000000000B000080010000000C000080050000000D000080050006000900120005000600F2000000B4000000070000000100010078000000000000000D000000A8000000000000001100008001000000120000800C000000130000800D0000001400008014000000150000801A00000016000080220000001700008023000000180000803F000000190000804B0000001A00008050000000EEEFFE8074000000EEEFFE80750000001D000080050006001000570009000A000D001F000D008000140048000D000E0011004F0011003A0011001E00000000000000000005000600F400000008000000A60000000000000010000000000000001C000000340000005400000000000000000000000000000000000000FFFFFFFF1A092FF12000000014020000550000000100000001000000010000001D000000010000003500000001000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000C0000001800000024000000746141636365737346756E630000000016002911000000002401000001003036303030303032000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001A00251100000000040000000100436F6E7374616E7446756E6300001600291100000000040000000100303630303030303100001E002511000000002401000001004461746141636365737346756E6300000000160029110000000024010000010030363030303030320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000FFFFFFFF1A092FF1000000000000000030303030303100001E002511000000002401000001004461746141636365737346756E63000000001600291100000000240100000100303630303030303200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000090000007C000000DB00000038000000FFFFFFFF3800000000000000CA0000008000000058000000080000000300000006000000070000000A000000090000000400000072632F66696C65732F633A5C646174615C6465765C746573745C636C7266756E6374696F6E706572666F726D616E63655C636C7266756E6374696F6E706572666F726D616E63655C7363616C617266756E6374696F6E732E6373000400000006000000010000001E00000000000000110000000700000022000000080000000A00000006000000000000000500000000000000DC51330100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001300000020000000DB00000038000000970100003800000000000000CA000000800000005800000028000000F0030000440200002C0000006C00000003000000130000000600000012000000070000000A0000000B00000008000000090000000C0000000D0000000E0000000F00000011000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000FFFFFFFF77093101030000000B00008E0C00FE070D000000600000003C0000002C000000B8000000000000000000000016000000190000000000EEC00000000000000000FFFF000000000000FFFFFFFF00000000FFFF0000000000000000000000000A00CC020000000000001001000001000000C05A5405000000000000000055736572446566696E656446756E6374696F6E730037314141414545380000002DBA2EF10100000000000000070000000000000000000000000000000000000001000000070000007800000000000000000000000000000000000000020002000D01000000000100FFFFFFFF000000007F0000000802000000000000FFFFFFFF00000000FFFFFFFF010001000000010052000000633A5C646174615C6465765C546573745C436C7246756E6374696F6E506572666F726D616E63655C436C7246756E6374696F6E506572666F726D616E63655C5363616C617246756E6374696F6E732E637300633A5C646174615C5265706F735C5365744D6555705C436C7246756E6374696F6E506572666F726D616E63655C436C7246756E6374696F6E506572666F726D616E63655C5363616C617246756E6374696F6E732E637300000000FEEFFEEF010000000100000000010000000000000000000000FFFFFFFFFFFFFFFFFFFF0900FFFFFFFFFFFFFFFFFFFF0000000000000000000000000000000000942E31017BAE6A590300000004592E73B7C3BF479AEE04CC022CA881E10000002F4C696E6B496E666F002F6E616D6573002F7372632F686561646572626C6F636B002F7372632F66696C65732F633A5C646174615C6465765C746573745C636C7266756E6374696F6E706572666F726D616E63655C636C7266756E6374696F6E706572666F726D616E63655C7363616C617266756E6374696F6E732E6373002F7372632F66696C65732F633A5C646174615C7265706F735C7365746D6575705C636C7266756E6374696F6E706572666F726D616E63655C636C7266756E6374696F6E706572666F726D616E63655C7363616C617266756E6374696F6E732E637300050000000A000000010000003E000000000000001100000007000000220000000800000000000000050000007F0000000F0000000A0000000600000000000000DC5133010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000440000004501000038000000EF010000380000000000000084010000AC0000005800000028000000F0030000440200002C0000006C000000FFFFFFFF5800000013000000160000000600000015000000070000000C0000000B00000004000000080000000D0000000E0000000F000000100000001200000011000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS N'ClrFunctionPerformance.pdb';


GO
PRINT N'Creating [dbo].[ConstantFunc]...';


GO
CREATE FUNCTION [dbo].[ConstantFunc]
( )
RETURNS INT
AS
 EXTERNAL NAME [ClrFunctionPerformance].[UserDefinedFunctions].[ConstantFunc]


GO
PRINT N'Creating [dbo].[DataAccessFunc]...';


GO
CREATE FUNCTION [dbo].[DataAccessFunc]
(@orderId INT NULL)
RETURNS INT
AS
 EXTERNAL NAME [ClrFunctionPerformance].[UserDefinedFunctions].[DataAccessFunc]


GO
PRINT N'Update complete.';


GO
