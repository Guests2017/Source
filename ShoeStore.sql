use master
if exists (select * from sys.databases where name = 'ShoeStore')
	drop database ShoeStore
go

create database ShoeStore
go
use ShoeStore
go


create table Unit
(
	ID int not null,
	UnitName nvarchar(50) not null
	constraint PK_Unit_ID primary key(ID)
)
go

create table InvoiceType 
(
	ID char(2) not null,
	TypeName nvarchar(50) not null
	constraint pk_InvoiceType primary key(ID)
)
go

create table Customer
(
	ID varchar(20) not null,
	CustName Nvarchar(50) Not null,
	Address	Nvarchar(MAX),
	Phone varchar(20),
	Fax	varchar(20),
	Email Nvarchar(50),
	Overdue	Int, 
	Amount	Decimal(10,3),
	DueAmt	Decimal	(10,3),
	Status	char(2),
	Description	Nvarchar(200),	
	constraint PK_Customer_CustID primary key (ID)
)
go

create table Employee
(
	ID varchar(20) not null,
	Name nvarchar(50) null,
	Phone varchar(20) null,
	Gender bit default 0,
	Address	nvarchar(70) null,
	StartDate date null,
	Position char(2) null,
	Email nvarchar(20) null,
	constraint pk_Employee_EmpID primary key (ID)
)
go

create table TransferOrder
(
	ID varchar(20) not null,
	Date datetime null,
	SalerID varchar(20) not null,
	StoreKeeperID varchar(20) not null,
	Description nvarchar(50) null,
	Type char(2) null,
	constraint PK_TransferOrder_ID primary key(ID),
	constraint FK_TransferOrder_EmployeeID foreign key (ID) references Employee(ID),
	constraint FK_TransferOrder_SalerID foreign key (SalerID) references Employee(ID),

)

create table Inventory 
(
	ID varchar(20)	not null,
	Name nvarchar(50)  null,
	ClassName nvarchar(50) null,
	Images varchar(50) null,
	UnitIDT	int  null,
	UnitIDL int  null,
	UnitRate int null,
	PriceT	Decimal(8,3)  null,
	PriceL	Decimal(8,3)  null,
	SlsTax Decimal(8,3) null,
	QtyStock	int,
	Status char(2), 
	Description nvarchar(200)
	constraint PK_Inventory_ID primary key (ID),
	constraint FK_Inventory_UnitIDT foreign key (UnitIDT) references Unit(ID),
	constraint FK_Inventory_UnitIDL foreign key (UnitIDL) references Unit(ID)
)

create table TransOrderDetail
(
	ID varchar(20) not null,
	TransID varchar(20) not null,
	InvtID varchar(20) not null,
	Quantity int null,
	constraint PK_TransOrderDetail_ID primary key (ID),
	constraint FK_TransOrderDetail_InvtID foreign key (InvtID) references Inventory(ID),
	constraint FK_TransOrderDetail_TransOrder foreign key (ID) references TransferOrder(ID)
)
go

create table Stock
(
	ID varchar(20) not null,
	StoreKeeperID varchar(20) not null,
	Address nvarchar(50) null,
	PostalCode int null
	constraint PK_Stock_ID primary key (ID),
	constraint FK_Stock_ID_EmpID foreign key (ID) references Employee(ID)

)
go

create table Vendor
(
	VendID varchar(20) Not null,
	VendorName Nvarchar(50)	Not null,
	Address	Nvarchar(MAX),
	Email varchar(50),		
	Phone varchar(20),	
	Fax	varchar(20),
	DueAmt Decimal(18,0)		,
	Amount	Decimal	(18,0)		,
	OverdueAmt	Decimal(18,0)		,
	Status char(2) Not null, --AV
	Description	Nvarchar(MAX),

	constraint pk_Vendor primary key (VendID)
)
go

create table SaleOrder
(
	ID	varchar(20) not null,
	Date datetime2 not null,
	Type	char(2) not null,
	CustID	varchar(20) not null,
	EmpID varchar(20) not null,
	OverdueDate	Datetime,
	OrderDisc Decimal(18,0),
	TaxAmt Decimal(18,0),
	TotalAmt Decimal(18,0),	
	Payment	Decimal(10,3),
	Debt Decimal(18,0),
	Description	Nvarchar(MAX)

	constraint PK_SaleOrder_SlsOrdID primary key (ID),
	constraint PK_SaleOrder_InvoiceType foreign key (Type) references InvoiceType(ID),
	constraint PK_SaleOrder_Customer foreign key (CustID) references Customer(ID),
	constraint PK_SaleOrder_Employee foreign key (EmpID) references Employee(ID)
)
go

create table StockTransfer
(
	TransID	varchar(20)	Not null,
	TransDate Datetime2,	
	FromStockID	Nvarchar(20)	Not null,
	ToStockID	Nvarchar(20)	Not null,
	TotalAmt	Decimal	,	
	Description	Nvarchar(200)	,

	constraint pk_StockTransfer primary key (TransID)
)
go

create table Distributor
(
	ID varchar(20) not null,
	Name nvarchar(50) null,
	Address nvarchar(50) null,
	Phone nvarchar(50) null,
	Fax varchar(20) null,
	Email nvarchar(50) null,
	PortalCode int null,
	constraint PK_Distributor_ID primary key (ID)
)
go

create table SalesOrderDetail 
(
	ID int identity(1,1),
	SaleOrderID varchar(20) not null,
	InvtID varchar(20) not null,
	Quantity int,
	SalesPrice Decimal(8,3),	
	Discount Decimal(8,3),	
	TaxAmt Decimal(8,3),

	constraint PK_SlsOrderDetail_ID primary key (ID),

	constraint FK_SlsOrderDetail_Inventory foreign key (InvtID) references Inventory(ID),
	constraint FK_SlsOrderDetail_SalesOrder foreign key (SaleOrderID) references SaleOrder(ID)
)
go

create table StkTransDetail
(
	TransID	varchar(20) Not null,
	InvtID	varchar(20)Not null,
	Qty	Int,
	Amount Decimal(18,0),		

	constraint pk_StkTransDetail primary key (TransID, InvtID),
	constraint fk_StkTransDetail_StockTransfer foreign key (TransID) references StockTransfer(TransID),
	constraint fk_StkTransDetail_InvtTransfer foreign key (InvtID) references Inventory(ID),
)
go

create table BuyOrder 
(
	ID int identity(1,1),
	Date datetime null,
	VendorID varchar(20) null,
	DistID varchar(20) not null,
	TotalMoney decimal(8,3) null,
	Type char(2) not null,
	Description nvarchar(50) null,
	constraint PK_BuyOrder_ID primary key (ID),
	constraint FK_BuyOrder_InvoiceType foreign key (Type) references InvoiceType(ID),
	constraint FK_BuyOrder_Distributor foreign key (DistID) references Distributor(ID),
	constraint FK_BuyOrder_Vendor foreign key (VendorID) references Vendor(VendID)
)
go

create table BuyOrderDetail
(
	ID int identity(1,1) ,
	BoID int null,
	InvtID varchar(20) null,
	Quantity int null,
	InvtPriceT decimal(8,3),
	InvtPriceL decimal(8,3),
	constraint PK_BuyOrderDetail primary key (ID),
	constraint FK_BuyOrderDetail_Inventory foreign key (InvtID) references Inventory(ID),
	constraint FK_BuyOrderDetail_BuyOrder foreign key (BoID) references BuyOrder(ID) 
)
go

create table Admin
(
	ID	int identity(1,1) primary key,
	UserAdmin varchar(50) not null,
	PassAdmin varchar(50) not null,
	Hoten nvarchar(50) null
)
go

create table Users
(
	ID int  identity(1,1) primary key,
	UserID varchar(50) not null,
	UserName varchar(50) not null,
	GroupID varchar(20) null,
)

--Unit
insert into Unit(ID,UnitName) values(0,N'NULL')
insert into Unit(ID,UnitName) values(1,N'Thùng')
insert into Unit(ID,UnitName) values(2,N'Lẻ')

select * from Unit

--Admin
insert into Admin(UserAdmin,PassAdmin,Hoten) values('admin','123456',N'Dương Thành Phết')
insert into Admin(UserAdmin,PassAdmin,Hoten) values('user','654321',N'Phết')

select * from Admin
--InvoiceType
insert into InvoiceType values('ND',N'NPP xuất hàng cho NVBH')
insert into InvoiceType values('NT',N'NVBH trả lại hàng cho NPP')
insert into InvoiceType values('IN',N'Bán hàng cho khách hàng trả tiền ngay')
insert into InvoiceType values('CM',N'Trả lại của đơn hàng IN')
insert into InvoiceType values('NP',N'NVBH bán hàng cho khách hàng')
insert into InvoiceType values('NM',N'Khách hàng trả lại hàng cho NVBH')
insert into InvoiceType values('PO',N'Hóa đơn mua hàng')
insert into InvoiceType values('PR',N'Trả lại hàng cho Cty')

select * from Inventory
--Employee
insert into Employee values('ad01',N'Dương Thành Phết','0123456654',0,N'35 Phạm ngũ lão','12/02/2012','AV',N'duongthanhphet@yahoo.com')
insert into Employee values('ad02',N'Phết','0123456654',0,N'123 Học lạc','03/23/2012','AV',N'mrphet@yahoo.com')
insert into Employee values('sa01',N'Nguyễn Văn B','0123456654',0,N'35 Hàm tử','12/02/2012','AV',N'nguyenvanb@yahoo.com')
insert into Employee values('sa02',N'Nguyễn Văn C','0123456654',0,N'123 Dương tử giang','03/23/2012','AV',N'nguyenvanc@yahoo.com')
insert into Employee values('sa03',N'Nguyễn Văn D','0123456345',0,N'22 Hồng bàng','12/02/2012','AV',N'nguyenvand@yahoo.com')
insert into Employee values('sa04',N'Nguyễn Văn E','0123456123',0,N'555 Nguyễn Trãi','12/02/2012','AV',N'nguyenvane@yahoo.com')
insert into Employee values('sk01',N'Trần Văn F','0123456654',0,N'35 Trần hưng đạo','12/02/2012','AV',N'tranvanf@yahoo.com')
insert into Employee values('sk02',N'Trần Văn G','0123456654',0,N'123 Lê hồng phong','03/23/2012','AV',N'tranvang@yahoo.com')
insert into Employee values('sk03',N'Trần Văn H','0123456345',0,N'22 Pastuer','12/02/2012','AV',N'tranvanh@yahoo.com')
insert into Employee values('sk04',N'Trần Văn E','0123456123',0,N'55 Lê lợi','12/02/2012','AV',N'tranvane@yahoo.com')

select * from Employee
--Nike
insert into Inventory values('1',N'Nike Air Forge 1`07',N'Men`s Shoe',N'Nike/p(1).png',0,2,1988000,0,1988,0,0,'AV',N'')
insert into Inventory values('2',N'Nike Roshe Two',N'Men`s Shoe',N'Nike/p(2).png',0,2,1988000,0,1988,0,0,'AV',N' ')
insert into Inventory values('3',N'Nike Roshe Tiempo VI FC',N'Men`s Shoe',N'Nike/p(3).png',0,2,3990000,0,3990,0,0,'AV',N' ')
insert into Inventory values('4',N'Nike SB Zoom Stefan Janoski OG',N'Men`s Shoe',N'Nike/p(4).png',0,2,1988000,0,1988,0,0,'AV',N' ')
insert into Inventory values('5',N'Nike All Court 2 Low',N'Men`s Shoe',N'Nike/p(5).png',0,2,1988000,0,1988,0,0,'AV',N' ')
insert into Inventory values('6',N'Nike SB Zoom Stefan Janoski OG',N'Men`s Shoe',N'Nike/p(6).png',0,2,2490000,0,2490,0,0,'AV',N' ')
insert into Inventory values('7',N'Nike Air Force 1 Low Premium iD',N'Men`s Shoe',N'Nike/p(7).png',0,2,4797000,0,4797,0,0,'AV',N' ')
insert into Inventory values('8',N'Nike Classic Cortez Nyloh Premium',N'Men`s Shoe',N'Nike/Lifestyle/p(8).png',0,2,2190000,0,2190,0,0,'AV',N' ')
insert into Inventory values('9',N'Nike Cortez Basic Nyloh Premium',N'Men`s Shoe',N'Nike/Lifestyle/p(9).png',0,2,2190000,0,2190,0,0,'AV',N' ')
insert into Inventory values('10',N'Nike Classic Cortez Leather',N'Men`s Shoe',N'Nike/Lifestyle/p(10).png',0,2,2190000,0,2190,0,0,'AV',N' ')
insert into Inventory values('11',N'Nike Mayfly Lite BR',N'Men`s Shoe',N'Nike/Lifestyle/p(11).png',0,2,3390000,0,3390,0,0,'AV',N' ')
insert into Inventory values('12',N'Nike Aqua Sock 360',N'Men`s Shoe',N'Nike/Lifestyle/p(12).png',0,2,2090000,0,2090,0,0,'AV',N' ')
insert into Inventory values('13',N'Nike Classic Cortez Leather SE',N'Men`s Shoe',N'Nike/Lifestyle/p(13).png',0,2,1738000,0,1738,0,0,'AV',N' ')
insert into Inventory values('14',N'Nike Free RN 2017 Solstice',N'Men`s Running Shoe',N'Nike/Running/p(1).png',0,2,2790000,0,2790,0,0,'AV',N' ')
insert into Inventory values('15',N'Nike Free RN',N'Men`s Running Shoe',N'Nike/Running/p(2).png',0,2,2790000,0,2790,0,0,'AV',N' ')
insert into Inventory values('16',N'Nike Lunar Skyelux',N'Men`s Running Shoe',N'Nike/Running/p(3).png',0,2,2790000,0,2790,0,0,'AV',N' ')
insert into Inventory values('17',N'Nike Air Max Sequent 2',N'Men`s Running Shoe',N'Nike/Running/p(4).png',0,2,2790000,0,2790,0,0,'AV',N' ')
insert into Inventory values('18',N'Nike Air Zoom Span',N'Men`s Running Shoe',N'Nike/Running/p(5).png',0,2,2790000,0,2790,0,0,'AV',N' ')
insert into Inventory values('19',N'Nike Flex 2017 RN',N'Men`s Running Shoe',N'Nike/Running/p(6).png',0,2,2390000,0,2390,0,0,'AV',N' ')
insert into Inventory values('20',N'Nike Flex Contact',N'Men`s Running Shoe',N'Nike/Running/p(7).png',0,2,1990000,0,1990,0,0,'AV',N' ')
insert into Inventory values('21',N'Nike Free RN',N'Men`s Running Shoe',N'Nike/Running/p(8).png',0,2,1848000,0,1848,0,0,'AV',N' ')
insert into Inventory values('22',N'Nike Air Zoom Pegasus 33',N'Men`s Running Shoe',N'Nike/Running/p(9).png',0,2,2708000,0,2708,0,0,'AV',N' ')
insert into Inventory values('23',N'Nike Air Zoom Pegasus',N'Men`s Running Shoe',N'Nike/Running/p(10).png',0,2,2368000,0,2368,0,0,'AV',N' ')
insert into Inventory values('24',N'Nike Mercurial Vortex III CR7 FG',N'Firm-Ground Football Boot',N'Nike/Football/p(1).png',0,2,1690000,0,1690,0,0,'AV',N' ')
insert into Inventory values('25',N'Nike Mercurial Victory VI Dynamic Fit CR7 FG',N'Firm-Ground Football Boot',N'Nike/Football/p(2).png',0,2,2690000,0,2690,0,0,'AV',N' ')
insert into Inventory values('26',N'Nike Mercurial Victory VI Dynamic Fit CR7 FG',N'Firm-Ground Football Boot',N'Nike/Football/p(3).png',0,2,2490000,0,2490,0,0,'AV',N' ')
insert into Inventory values('27',N'Nike Mercurial Victory VI FG',N'Firm-Ground Football Boot',N'Nike/Football/p(4).png',0,2,2190000,0,2190,0,0,'AV',N' ')
insert into Inventory values('28',N'Nike Tiempo Genio II Leather FG',N'Firm-Ground Football Boot',N'Nike/Football/p(5).png',0,2,1790000,0,1790,0,0,'AV',N' ')
insert into Inventory values('29',N'Nike TiempoX Genio II Leather TF',N'Firm-Ground Football Boot',N'Nike/Football/p(6).png',0,2,1790000,0,1790,0,0,'AV',N' ')
insert into Inventory values('30',N'Nike Hypervenom Phelon 3 FG',N'Firm-Ground Football Boot',N'Nike/Football/p(7).png',0,2,2190000,0,2190,0,0,'AV',N' ')
insert into Inventory values('31',N'Nike HypervenomX Phade 3 TF',N'Turf Football Shoe',N'Nike/Football/p(8).png',0,2,1490000,0,1490,0,0,'AV',N' ')
insert into Inventory values('32',N'Nike HypervenomX Phade 3 IC',N'Indoor/Court Football Boot',N'Nike/Football/p(9).png',0,2,1038000,0,1038,0,0,'AV',N' ')
insert into Inventory values('33',N'Nike Hypervenom Phelon II FG',N'Firm-Ground Football Boot',N'Nike/Football/p(10).png',0,2,2090000,0,2090,0,0,'AV',N' ')
insert into Inventory values('34',N'Nike Hypervenom Phelon II TF',N'Firm-Ground Football Boot',N'Nike/Football/p(11).png',0,2,1668000,0,1668,0,0,'AV',N' ')
insert into Inventory values('35',N'Nike Hypervenom Phelon II IC',N'Firm-Ground Football Boot',N'Nike/Football/p(12).png',0,2,1248000,0,1248,0,0,'AV',N' ')
insert into Inventory values('36',N'Nike Tiempo Legacy II FG',N'Firm-Ground Football Boot',N'Nike/Football/p(13).png',0,2,2368000,0,2368,0,0,'AV',N' ')
insert into Inventory values('37',N'Nike Mercurial Vortex III IC',N'Indoor/Court Football Shoe',N'Nike/Football/p(14).png',0,2,1038000,0,1038,0,0,'AV',N' ')
insert into Inventory values('38',N'Nike Tiempo Genio II Leather IC',N'Indoor/Court Football Shoe',N'Nike/Football/p(15).png',0,2,1790000,0,1790,0,0,'AV',N' ')
insert into Inventory values('39',N'Nike Metcon 3',N'Men`s Trainning Shoe',N'Nike/Trainning/p(1).png',0,2,2948000,0,2948,0,0,'AV',N'The fully updated Nike Metcon 3 Men`s Training Shoe is ready for your most demanding workouts—from wall exercises and rope climbs to sprinting and lifting.')
insert into Inventory values('40',N'Nike Metcon 3',N'Men`s Trainning Shoe',N'Nike/Trainning/p(2).png',0,2,2948000,0,2948,0,0,'AV',N'DURABLE AND STABLE The fully updated Nike Metcon 3 Men`s Training Shoe is ready for your most demanding workouts—from wall exercises and rope climbs to sprinting and lifting.')
insert into Inventory values('41',N'Nike Free Train Versatility',N'Men`s Trainning Shoe',N'Nike/Trainning/p(3).png',0,2,2468000,0,2468,0,0,'AV',N'FLEXIBLE AND SUPPORTIVE
The Nike Free Train Versatility Men`s Training Shoe gives you the flexible support you need for intense and varied workouts')
insert into Inventory values('42',N'Nike Free Train Versatility',N'Men`s Trainning Shoe',N'Nike/Trainning/p(4).png',0,2,2158000,0,2158,0,0,'AV',N'FLEXIBLE AND SUPPORTIVE
The Nike Free Train Versatility Men`s Training Shoe gives you the flexible support you need for intense and varied workouts')
insert into Inventory values('43',N'Nike Free Train Versatility',N'Men`s Trainning Shoe',N'Nike/Trainning/p(5).png',0,2,2158000,0,2158,0,0,'AV',N'FLEXIBLE AND SUPPORTIVE
The Nike Free Train Versatility Men`s Training Shoe gives you the flexible support you need for intense and varied workouts')
insert into Inventory values('44',N'Nike Zoom Train Complete',N'Men`s Trainning Shoe',N'Nike/Trainning/p(6).png',0,2,2158000,0,2158,0,0,'AV',N'ULTRA-RESPONSIVE CUSHIONING
The Nike Zoom Train Complete.')
insert into Inventory values('45',N'Nike Zoom Train Complete',N'Men`s Trainning Shoe',N'Nike/Trainning/p(7).png',0,2,2158000,0,2158,0,0,'AV',N'ULTRA-RESPONSIVE CUSHIONING
The Nike Zoom Train Complete.')
insert into Inventory values('46',N'Nike Zoom Train Complete',N'Men`s Trainning Shoe',N'Nike/Trainning/p(8).png',0,2,2158000,0,2158,0,0,'AV',N'ULTRA-RESPONSIVE CUSHIONING
The Nike Zoom Train Complete.')
insert into Inventory values('47',N'Nike Zoom Live EP',N'Men`s Basketball Shoe',N'Nike/Basketball/p(1).png',0,2,2790000,0,2790,0,0,'AV',N'LIGHTWEIGHT AND LOCKED IN
The Nike Zoom Live 2017 Men`s Basketball Shoe features a light textile upper and midfoot strap for fast, in-control play')
insert into Inventory values('48',N'Nike Tiempo Genio II Leather IC',N'Men`s Basketball Shoe',N'Nike/Basketball/p(2).png',0,2,2790000,0,2790,0,0,'AV',N'BUILT FOR FAST, DYNAMIC PLAY.
The Nike Kobe Mamba Instinct Men`s Basketball Shoe is designed to keep you light and fast on your feet with a lightweight Flyweave upper and springy cushioning. ')
insert into Inventory values('49',N'Nike Tiempo Genio II Leather IC',N'Men`s Basketball Shoe',N'Nike/Basketball/p(3).png',0,2,2790000,0,2790,0,0,'AV',N'LIGHTWEIGHT SUPPORT. RESPONSIVE CUSHIONING.
The Nike Lebron Witness Men`s Basketball Shoe features an innovative')
insert into Inventory values('50',N'Nike Tiempo Genio II Leather IC',N'Men`s Basketball Shoe',N'Nike/Basketball/p(4).png',0,2,3428000,0,3428,0,0,'AV',N'RESPONSIVE AT EVERY ANGLE
With a cutting-edge cushioning system, the Nike Zoom KD 9 Men`s Basketball Shoe delivers enhanced responsiveness and control for versatile play.')
insert into Inventory values('51',N'Nike Tiempo Genio II Leather IC',N'Men`s Basketball Shoe',N'Nike/Basketball/p(5).png',0,2,3188000,0,3188,0,0,'AV',N'RESPONSIVE AT EVERY ANGLE
With a cutting-edge cushioning system, the Nike Zoom KD 9 Men`s Basketball Shoe delivers enhanced responsiveness and control for versatile play.')
insert into Inventory values('52',N'Nike Tiempo Genio II Leather IC',N'Men`s Basketball Shoe',N'Nike/Basketball/p(6).png',0,2,2368000,0,2368,0,0,'AV',N'RESPONSIVE AT EVERY ANGLE
With a cutting-edge cushioning system, the Nike Zoom KD 9 Men`s Basketball Shoe delivers enhanced responsiveness and control for versatile play.')

select * from Inventory
--Customer
insert into Customer values('1',N'Trần Trọng Quý',N'13 Huyền Trân','0123242112','023-325',N'trantrongquy@yahoo.com',0,0,0,'AV',N' ')
insert into Customer values('2',N'Trần Văn Bình',N'168 3/2','0123242333',' ',N'tranvanbinh@yahoo.com',0,0,0,'AV',N' ')
insert into Customer values('3',N'Nguyễn Sơn Duy',N'135 Bắc Hải','0123343545',' ',N'nguyensonduy@yahoo.com',0,0,0,'AV',N' ')
insert into Customer values('4',N'Nguyễn Trọng Nghĩa',N'258 Lý Thường Kiệt','0123242112',' ',N'trongnghia@yahoo.com',0,0,0,'AV',N' ')
insert into Customer values('5',N'Cao Bằng',N'15 Lạc Long Quân','0123242112',' ',N'caobang@yahoo.com',0,0,0,'AV',N' ')

select * from Customer
--Vendor
insert into Vendor values('1',N'Far Eastern New Century - FENC',N'46 Đại Lộ Tự Do, KCN Việt Nam - Singapore',N'contact@careerbuilder.vn','3822-6060',' ',0,0,0,'AV',N' ')

select * from Vendor
--Distributor
insert into Distributor values('1',N'Far Eastern New Century - FENC',N'46 Đại Lộ Tự Do, KCN Việt Nam - Singapore','3822-6060',' ',N'contact@careerbuilder.vn',0)

select * from Distributor
--StockTransfer
insert into StockTransfer values(N'XK01','5/15/2007','B01','F01',100,N'Kho B01 bảo trì')
insert into StockTransfer values(N'XK02','9/8/2007','F01','A01',50,N'Kho F01 ngưng hoạt động')
insert into StockTransfer values(N'XK03','1/1/2008','A01','E01',200,N'Kho A01 tu sửa')
insert into StockTransfer values(N'XK04','5/18/2008','E01','C01',100,N'Kho E01 mở rộng')
insert into StockTransfer values(N'XK05','8/16/2008','C01','A01',100,N'Thuận lợi cho công tác quản lý, bán hàng')

select * from StockTransfer
--Users

insert into Users values('vanb','123456','sa01')
insert into Users values('vanc','vanc','sa02')
insert into Users values('vand','12345','sa03')
insert into Users values('vane','vane','sa04')
insert into Users(UserID,UserName) values('guest01','guest')

