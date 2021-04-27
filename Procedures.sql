USE [WideWorldImporters]
---------------------------------------------------------PROCEDURES_CLIENTE------------------------------------------------------------------------------------------
----------------------------------------------------ESPECIFICA-----------------------------------------------
GO
CREATE PROCEDURE proceClienteEspecifica(@pID INT) AS
	SELECT 
		CustomerName AS Customer,
		CustomerCategoryName AS CustomerCategory,
		BuyingGroupName AS BuyingGroup,
		ApPeoPC.FullName AS PrimaryContactPerson,
		ApPeoAC.FullName AS AlternateContactPerson,
		DeliveryMethodName,
		CityName,
		DeliveryPostalCode,
		CUST.PhoneNumber,
		CUST.FaxNumber,
		PaymentDays,
		WebsiteURL,
		DeliveryAddressLine1,
		DeliveryAddressLine2,
		DeliveryLocation
	FROM WideWorldImporters.SALES.Customers CUST
	LEFT OUTER JOIN WideWorldImporters.Sales.CustomerCategories CUSCAT ON CUSCAT.CustomerCategoryID = CUST.CustomerCategoryID
	LEFT OUTER JOIN WideWorldImporters.Application.DeliveryMethods DIVMET ON DIVMET.DeliveryMethodID = CUST.DeliveryMethodID
	LEFT OUTER JOIN WideWorldImporters.Sales.BuyingGroups SABUYGROU ON SABUYGROU.BuyingGroupID = CUST.BuyingGroupID
	LEFT OUTER JOIN WideWorldImporters.Application.People ApPeoPC ON ApPeoPC.PersonID = CUST.PrimaryContactPersonID
	LEFT OUTER JOIN (SELECT PersonID,FullName FROM WideWorldImporters.Application.People) ApPeoAC ON ApPeoAC.PersonID = CUST.AlternateContactPersonID
	LEFT OUTER JOIN WideWorldImporters.Application.Cities ApDelCit on ApDelCit.CityID = CUST.DeliveryCityID
	WHERE CustomerID = @pID;
;
----------------------------------------------------GENERAL--------------------------------------------------
GO
CREATE PROCEDURE proceClienteGeneral (@pName VARCHAR(102), @pCategory VARCHAR(52), @pDeliveryMethod VARCHAR(52)) AS
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(700) = 'SELECT CustomerID,CustomerName,CustomerCategoryName,DeliveryMethodName FROM WideWorldImporters.SALES.Customers CUST INNER JOIN WideWorldImporters.Sales.CustomerCategories CUSCAT ON CUSCAT.CustomerCategoryID = CUST.CustomerCategoryID INNER JOIN WideWorldImporters.Application.DeliveryMethods DIVMET ON DIVMET.DeliveryMethodID = CUST.DeliveryMethodID '
	IF (NOT @pName LIKE '')					-----@pName
	BEGIN
		SET @pName = '%' + @pName + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE UPPER (CustomerName) LIKE UPPER(@pName) ';
	END
	IF (NOT @pCategory LIKE '')				-----@pCategory
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pCategory = '%' + @pCategory + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (CustomerCategoryName) LIKE UPPER(@pCategory) ';
	END
	IF (NOT @pDeliveryMethod LIKE '')		-----@pDeliveryMethod
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pDeliveryMethod = '%' + @pDeliveryMethod + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (DeliveryMethodName) LIKE UPPER(@pDeliveryMethod) ';
	  END
	SET @CONSULTA = @CONSULTA + ' ORDER BY CustomerName ASC;'
	EXEC SP_EXECUTESQL @consulta, N'@pName varchar(102), @pCategory VARCHAR(52), @pDeliveryMethod VARCHAR(52)',@pName, @pCategory, @pDeliveryMethod
;
---------------------------------------------------------PROCEDURES_PROVEEDORES--------------------------------------------------------------------------------------
----------------------------------------------------ESPECIFICA-----------------------------------------------
GO
CREATE PROCEDURE proceProveedorEspecifica(@pID INT) AS
	SELECT
		PSUP.SupplierReference,
		PSUP.SupplierName,
		PSUPCAT.SupplierCategoryName,
		ApPeoPC.FullName AS PrimaryContactPerson,
		ApPeoAC.FullName AS AlternateContactPerson,
		DIVMET.DeliveryMethodName,
		PSUP.DeliveryPostalCode,
		PSUP.PhoneNumber,
		PSUP.FaxNumber,
		PSUP.WebsiteURL,
		(DeliveryAddressLine2 + ', ' + DeliveryAddressLine1) as Address,
		PSUP.DeliveryLocation,
		PSUP.BankAccountBranch,
		PSUP.BankAccountNumber
	FROM WideWorldImporters.Purchasing.Suppliers PSUP 
	INNER JOIN WideWorldImporters.Purchasing.SupplierCategories PSUPCAT ON PSUPCAT.SupplierCategoryID = PSUP.SupplierCategoryID 
	INNER JOIN WideWorldImporters.Application.DeliveryMethods DIVMET ON DIVMET.DeliveryMethodID = PSUP.DeliveryMethodID
	LEFT OUTER JOIN WideWorldImporters.Application.People ApPeoPC ON ApPeoPC.PersonID = PSUP.PrimaryContactPersonID
	LEFT OUTER JOIN (SELECT PersonID,FullName FROM WideWorldImporters.Application.People) ApPeoAC ON ApPeoAC.PersonID = PSUP.AlternateContactPersonID
	WHERE SupplierID = @pID;
;
----------------------------------------------------GENERAL--------------------------------------------------
GO
CREATE PROCEDURE proceProveedoresGeneral (@pName VARCHAR(102), @pCategory VARCHAR(52), @pDeliveryMethod VARCHAR(52)) AS
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(700) = 'SELECT PSUP.SupplierID,PSUP.SupplierName,PSUPCAT.SupplierCategoryName,DIVMET.DeliveryMethodName FROM WideWorldImporters.Purchasing.Suppliers PSUP INNER JOIN WideWorldImporters.Purchasing.SupplierCategories PSUPCAT ON PSUPCAT.SupplierCategoryID = PSUP.SupplierCategoryID INNER JOIN WideWorldImporters.Application.DeliveryMethods DIVMET ON DIVMET.DeliveryMethodID = PSUP.DeliveryMethodID '
	IF (NOT @pName LIKE '')					-----@pName
	BEGIN
		SET @pName = '%' + @pName + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE UPPER (PSUP.SupplierName) LIKE UPPER(@pName) ';
	END
	IF (NOT @pCategory LIKE '')				-----@pCategory
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pCategory = '%' + @pCategory + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (PSUPCAT.SupplierCategoryName) LIKE UPPER(@pCategory) ';
	END
	IF (NOT @pDeliveryMethod LIKE '')		-----@pDeliveryMethod
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pDeliveryMethod = '%' + @pDeliveryMethod + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (DIVMET.DeliveryMethodName) LIKE UPPER(@pDeliveryMethod) ';
	  END
	SET @CONSULTA = @CONSULTA + ' ORDER BY PSUP.SupplierName ASC;'
	EXEC SP_EXECUTESQL @consulta, N'@pName varchar(102), @pCategory VARCHAR(52), @pDeliveryMethod VARCHAR(52)',@pName, @pCategory, @pDeliveryMethod
;
---------------------------------------------------------PROCEDURES_INVENTARIO--------------------------------------------------------------------------------------
----------------------------------------------------ESPECIFICA-----------------------------------------------
GO
CREATE PROCEDURE proceInventarioEspecifica(@pID INT) AS
	SELECT
		STOITM.StockItemName,
		PURSUP.SupplierName,
		WARCOL.ColorName AS Color,
		PACTYPUP.PackageTypeName AS UnitPackage,
		PACTYPOP.PackageTypeName AS OuterPackageID,
		QuantityPerOuter,
		STOITM.Brand,
		STOITM.Size,
		STOITM.TaxRate,
		STOITM.UnitPrice,
		STOITM.RecommendedRetailPrice,
		STOITM.TypicalWeightPerUnit,
		STOITM.SearchDetails,
		STOITMHOL.QuantityOnHand,
		STOITMHOL.BinLocation
	FROM WideWorldImporters.Warehouse.StockItems STOITM
	LEFT OUTER  JOIN WideWorldImporters.Purchasing.Suppliers PURSUP ON PURSUP.SupplierID = STOITM.SupplierID
	LEFT OUTER  JOIN WideWorldImporters.Warehouse.StockItemHoldings STOITMHOL ON STOITMHOL.StockItemID = STOITM.StockItemID
	LEFT OUTER  JOIN WideWorldImporters.Warehouse.Colors WARCOL ON WARCOL.ColorID = STOITM.ColorID
	LEFT OUTER  JOIN WideWorldImporters.Warehouse.PackageTypes PACTYPUP ON PACTYPUP.PackageTypeID = STOITM.UnitPackageID
	LEFT OUTER  JOIN WideWorldImporters.Warehouse.PackageTypes PACTYPOP ON PACTYPOP.PackageTypeID = STOITM.OuterPackageID
	WHERE STOITM.StockItemID = @pID;
;
----------------------------------------------------GENERAL--------------------------------------------------
GO
CREATE PROCEDURE proceInventariosGeneral (@pProdName VARCHAR(102), @pGroup VARCHAR(52), @CantStock INT) AS	
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(900) = 'SELECT STOITM.StockItemID,STOITM.StockItemName,STOGROUP.StockGroupName,STOITMHOL.LastStocktakeQuantity FROM WideWorldImporters.Warehouse.StockItems STOITM INNER JOIN WideWorldImporters.Warehouse.StockItemHoldings STOITMHOL ON STOITMHOL.StockItemID = STOITM.StockItemID INNER JOIN WideWorldImporters.Warehouse.StockItemStockGroups STITGR ON STITGR.StockItemID = STOITM.StockItemID INNER JOIN WideWorldImporters.Warehouse.StockGroups STOGROUP ON STOGROUP.StockGroupID = STITGR.StockGroupID '
	IF (NOT @pProdName LIKE '')					-----@pProdName
	BEGIN
		SET @pProdName = '%' + @pProdName + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE UPPER (STOITM.StockItemName) LIKE UPPER(@pProdName) ';
	END
	IF (NOT @pGroup LIKE '')					-----@pGroup
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pGroup = '%' + @pGroup + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (STOGROUP.StockGroupName) LIKE UPPER(@pGroup) ';
	END
	IF (NOT @CantStock = 0)			-----@pDeliveryMethod
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'STOITMHOL.LastStocktakeQuantity = @CantStock ';
	  END
	SET @CONSULTA = @CONSULTA + ' ORDER BY STOITM.StockItemName ASC;'
	EXEC SP_EXECUTESQL @consulta, N'@pProdName varchar(102), @pGroup VARCHAR(52), @CantStock INT',@pProdName, @pGroup, @CantStock
;
---------------------------------------------------------PROCEDURES_VENTAS--------------------------------------------------------------------------------------
----------------------------------------------------ESPECIFICA-----------------------------------------------
GO
CREATE PROCEDURE proceVentaEspecifica(@pID INT) AS
	SELECT
		INV.InvoiceID,		--Numero de factura??
		CUST.CustomerName,
		DIVMET.DeliveryMethodName,
		CustomerPurchaseOrderNumber,
		ApPeoCont.FullName AS ContactPerson,
		ApsALPeo.FullName AS SalesPerson,
		INV.InvoiceDate,
		INV.DeliveryInstructions,
		WARSTOITM.StockItemName,
		WARSTOITMLIN.Quantity,
		WARSTOITMLIN.UnitPrice,
		WARSTOITMLIN.TaxRate,
		(WARSTOITMLIN.UnitPrice*(WARSTOITMLIN.TaxRate*0.01)) as TaxAmount,
		WARSTOITMLIN.ExtendedPrice
	FROM WideWorldImporters.Sales.Invoices INV
	INNER JOIN WideWorldImporters.Sales.Customers CUST ON CUST.CustomerID = INV.CustomerID
	INNER JOIN WideWorldImporters.Application.DeliveryMethods DIVMET ON DIVMET.DeliveryMethodID = INV.DeliveryMethodID
	INNER JOIN WideWorldImporters.Application.People ApPeoCont ON ApPeoCont.PersonID = INV.ContactPersonID
	INNER JOIN (SELECT PersonID,FullName FROM WideWorldImporters.Application.People) ApsALPeo ON ApsALPeo.PersonID = INV.SalespersonPersonID
	INNER JOIN WideWorldImporters.Sales.InvoiceLines WARSTOITMLIN ON WARSTOITMLIN.InvoiceID = INV.InvoiceID
	INNER JOIN WideWorldImporters.Warehouse.StockItems WARSTOITM ON WARSTOITM.StockItemID = WARSTOITMLIN.StockItemID
	WHERE INV.InvoiceID = @pID
;
----------------------------------------------------GENERAL--------------------------------------------------
GO
CREATE PROCEDURE proceVentasGeneral (@NFactura INT,@pCustName VARCHAR(102), @pDeliveryMethod VARCHAR(52),@MinFecha DATE,@MaxFecha DATE,@MinMonto INT,@MaxMonto INT) AS	
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(1000) = 'SELECT INV.InvoiceID, CUST.CustomerName, DIVMET.DeliveryMethodName, INV.InvoiceDate, SUM(WARSTOITMLIN.ExtendedPrice) AS TotalAmount FROM WideWorldImporters.Sales.Invoices INV INNER JOIN WideWorldImporters.Sales.Customers CUST ON CUST.CustomerID = INV.CustomerID INNER JOIN WideWorldImporters.Application.DeliveryMethods DIVMET ON DIVMET.DeliveryMethodID = INV.DeliveryMethodID INNER JOIN WideWorldImporters.Sales.InvoiceLines WARSTOITMLIN ON WARSTOITMLIN.InvoiceID = INV.InvoiceID '	
	IF (NOT @NFactura = 0)									-----@pName
	BEGIN
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE INV.InvoiceID = @NFactura ';
	END
	IF (NOT @pCustName LIKE '')								-----@pCustName
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pCustName = '%' + @pCustName + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (CUST.CustomerName) LIKE UPPER(@pCustName) ';
	END
	IF (NOT @pDeliveryMethod LIKE '')						-----@pDeliveryMethod
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @pDeliveryMethod = '%' + @pDeliveryMethod + '%';
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'UPPER (DIVMET.DeliveryMethodName) LIKE UPPER(@pDeliveryMethod) ';
	END
	IF (NOT @MinFecha = '1900-01-01')						-----@MinFecha
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'INV.InvoiceDate >= @MinFecha ';
	END
	IF (NOT @MaxFecha = '1900-01-01')						-----@MaxFecha
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'INV.InvoiceDate <= @MaxFecha ';
	END
	SET @SEVERALCOLUMNS = 0
	SET @CONSULTA = @CONSULTA + 'GROUP BY INV.InvoiceID, CUST.CustomerName, DIVMET.DeliveryMethodName, INV.InvoiceDate '
	IF (NOT @MinMonto = 0)									-----@@MinMonto
	BEGIN
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'HAVING SUM(WARSTOITMLIN.ExtendedPrice) >= @MinMonto ';
	END
	IF (NOT @MaxMonto = 0)									-----@MaxMonto
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @CONSULTA = @CONSULTA + 'HAVING ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'SUM(WARSTOITMLIN.ExtendedPrice) <= @MaxMonto ';
	END
	SET @CONSULTA = @CONSULTA + ' ORDER BY CUST.CustomerName ASC;'
	EXEC SP_EXECUTESQL @consulta, N'@NFactura INT,@MinFecha DATE,@MaxFecha DATE,@pCustName varchar(102),@MinMonto INT,@MaxMonto INT, @pDeliveryMethod VARCHAR(52)',@NFactura,@MinFecha,@MaxFecha,@pCustName,@MinMonto,@MaxMonto, @pDeliveryMethod
;
---------------------------------------------------------PROCEDURES_ESTADISTICAS--------------------------------------------------------------------------------
----------------------------------------------------PRIMERA--------------------------------------------------
GO
CREATE PROCEDURE procePrimeroEstadistico (@Name VARCHAR(102)) AS
	SELECT 
		SupplierName = (case GROUPING(SupplierName) when 1 then 'Total' else SupplierName end),
		SupplierCategoryName = (case GROUPING(SupplierCategoryName) when 1 then (case GROUPING(SupplierName) when 0 then 'SubTotal' else ' ' end) else SupplierCategoryName end),
		MAX(PPUORLINE.ORDERTOTAL) AS Major,
		Min(PPUORLINE.ORDERTOTAL) AS Minor,
		AVG(PPUORLINE.ORDERTOTAL) AS Average
	FROM WideWorldImporters.Purchasing.PurchaseOrders PPUORDER
	INNER JOIN (SELECT PurchaseOrderID,SUM(OrderedOuters*ExpectedUnitPricePerOuter) AS ORDERTOTAL FROM WideWorldImporters.Purchasing.PurchaseOrderLines GROUP BY PurchaseOrderID) PPUORLINE ON PPUORLINE.PurchaseOrderID = PPUORDER.PurchaseOrderID
	INNER JOIN WideWorldImporters.Purchasing.Suppliers PUSUPP ON PUSUPP.SupplierID = PPUORDER.SupplierID
	INNER JOIN WideWorldImporters.Purchasing.SupplierCategories PUSUPCAT ON PUSUPCAT.SupplierCategoryID = PUSUPP.SupplierCategoryID
	WHERE UPPER(PUSUPP.SupplierName) LIKE UPPER('%' + @Name + '%')
	GROUP BY ROLLUP(PUSUPP.SupplierName,PUSUPCAT.SupplierCategoryName);
;
----------------------------------------------------SEGUNDA--------------------------------------------------
GO
CREATE PROCEDURE proceSegundoEstadistico (@Name VARCHAR(102)) AS
	SELECT
		CustomerName = (case GROUPING(CustomerName) when 1 then 'Total' else CustomerName end),
		CustomerCategoryName = (case GROUPING(CustomerCategoryName) when 1 then (case GROUPING(CustomerName) when 0 then 'SubTotal' else ' ' end) else CustomerCategoryName end),
		MAX(TOTALINVOICE) AS Major,
		Min(TOTALINVOICE) AS Minor,
		AVG(TOTALINVOICE) AS Average
	FROM WideWorldImporters.Sales.InvoiceS SAINVOICE 
	INNER JOIN (SELECT InvoiceID,SUM(ExtendedPrice) AS TOTALINVOICE FROM WideWorldImporters.Sales.InvoiceLines GROUP BY InvoiceID) SAINVLINE ON SAINVLINE.InvoiceID = SAINVOICE.InvoiceID
	INNER JOIN WideWorldImporters.Sales.Customers SACUST ON SACUST.CustomerID = SAINVOICE.CustomerID
	INNER JOIN WideWorldImporters.Sales.CustomerCategories SACUSCAT ON SACUSCAT.CustomerCategoryID = SACUST.CustomerCategoryID
	WHERE UPPER(SACUST.CustomerName) LIKE UPPER('%' + @Name + '%')
	GROUP BY ROLLUP(SACUST.CustomerName,SACUSCAT.CustomerCategoryName)
	ORDER BY MAJOR;
;
----------------------------------------------------TERCERA--------------------------------------------------
GO
CREATE PROCEDURE proceTerceroEstadistico (@MinYear INT,@MaxYear INT,@MinMonth INT,@MaxMonth INT) AS
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(900) = 'SELECT TOP 10 STOITEM.StockItemName,SUM(ExtendedPrice-(Quantity*LastCostPrice)) AS Gain FROM WideWorldImporters.Sales.InvoiceLines SAINLINE INNER JOIN WideWorldImporters.Warehouse.StockItemHoldings STITHO ON STITHO.StockItemID = SAINLINE.StockItemID INNER JOIN WideWorldImporters.Sales.Invoices SALINVOICE ON SALINVOICE.InvoiceID = SAINLINE.InvoiceID INNER JOIN WideWorldImporters.Warehouse.StockItems STOITEM ON STOITEM.StockItemID = SAINLINE.StockItemID '
	IF (NOT @MinYear = 0)					-----@MinYear
	BEGIN
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE YEAR(SALINVOICE.InvoiceDate) >= @MinYear ';
	END
	IF (NOT @MaxYear = 0)					-----@MaxYear
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'YEAR(SALINVOICE.InvoiceDate) <= @MaxYear ';
	END
	IF (NOT @MinMonth = 0)					-----@MinMonth
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'Month(SALINVOICE.InvoiceDate)  >= @MinMonth ';
	  END
	IF (NOT @MaxMonth = 0)					-----@MaxMonth
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'Month(SALINVOICE.InvoiceDate)  <= @MaxMonth ';
	  END
	SET @CONSULTA = @CONSULTA + ' GROUP BY STOITEM.StockItemName ORDER BY Gain DESC;'
	print (@CONSULTA)
	EXEC SP_EXECUTESQL @consulta, N'@MinYear INT,@MaxYear INT,@MinMonth INT,@MaxMonth INT',@MinYear,@MaxYear,@MinMonth,@MaxMonth
;
----------------------------------------------------CUARTA---------------------------------------------------
GO
CREATE PROCEDURE proceCuartoEstadistico (@MinYear INT,@MaxYear INT,@MinMonth INT,@MaxMonth INT) AS
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(900) = 'SELECT TOP 10 SALCUST.CustomerName,COUNT(SALINVOICE.InvoiceID) AS QuantityInvoiced,SUM(TOTALINVOICE) AS TotallyFatigued FROM WideWorldImporters.Sales.Invoices SALINVOICE INNER JOIN (SELECT InvoiceID,SUM(ExtendedPrice) AS TOTALINVOICE FROM WideWorldImporters.Sales.InvoiceLines GROUP BY InvoiceID) SAINVLINE ON SAINVLINE.InvoiceID = SALINVOICE.InvoiceID INNER JOIN WideWorldImporters.Sales.Customers SALCUST ON SALCUST.CustomerID = SALINVOICE.CustomerID '
	IF (NOT @MinYear = 0)					-----@MinYear
	BEGIN
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE YEAR(SALINVOICE.InvoiceDate) >= @MinYear ';
	END
	IF (NOT @MaxYear = 0)					-----@MaxYear
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'YEAR(SALINVOICE.InvoiceDate) <= @MaxYear ';
	END
	IF (NOT @MinMonth = 0)					-----@MinMonth
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'Month(SALINVOICE.InvoiceDate)  >= @MinMonth ';
	  END
	IF (NOT @MaxMonth = 0)					-----@MaxMonth
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'Month(SALINVOICE.InvoiceDate)  <= @MaxMonth ';
	  END
	SET @CONSULTA = @CONSULTA + ' GROUP BY SALCUST.CustomerName ORDER BY QuantityInvoiced DESC;'
	EXEC SP_EXECUTESQL @consulta, N'@MinYear INT,@MaxYear INT,@MinMonth INT,@MaxMonth INT',@MinYear,@MaxYear,@MinMonth,@MaxMonth
;	
----------------------------------------------------QUINTA---------------------------------------------------
GO
CREATE PROCEDURE proceQuintoEstadistico (@MinYear INT,@MaxYear INT,@MinMonth INT,@MaxMonth INT) AS
	DECLARE	@SEVERALCOLUMNS BIT = 0;
	DECLARE	@CONSULTA NVARCHAR(900) = 'SELECT TOP 10 PURSUPP.SupplierName,COUNT(PUPUORLINE.PurchaseOrderID) AS QuantityOrders,SUM(PUPUORLINE.OrderTotal) AS TotalOrders FROM WideWorldImporters.Purchasing.PurchaseOrders PUPUORDER INNER JOIN (SELECT PurchaseOrderID, SUM (OrderedOuters*ExpectedUnitPricePerOuter) AS OrderTotal FROM WideWorldImporters.Purchasing.PurchaseOrderLines GROUP BY PurchaseOrderID) PUPUORLINE ON PUPUORLINE.PurchaseOrderID = PUPUORDER.PurchaseOrderID INNER JOIN WideWorldImporters.Purchasing.Suppliers PURSUPP ON PUPUORDER.SupplierID = PURSUPP.SupplierID '
	IF (NOT @MinYear = 0)					-----@MinYear
	BEGIN
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'WHERE YEAR(PUPUORDER.OrderDate) >= @MinYear ';
	END
	IF (NOT @MaxYear = 0)					-----@MaxYear
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'YEAR(PUPUORDER.OrderDate) <= @MaxYear ';
	END
	IF (NOT @MinMonth = 0)					-----@MinMonth
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'Month(PUPUORDER.OrderDate)  >= @MinMonth ';
	  END
	IF (NOT @MaxMonth = 0)					-----@MaxMonth
	BEGIN
		IF (@SEVERALCOLUMNS = 0) 
		BEGIN
			SET @SEVERALCOLUMNS = 1;
			SET @CONSULTA = @CONSULTA + 'WHERE ';
		END
		ELSE
		BEGIN 
			SET @CONSULTA = @CONSULTA + 'AND ';
		END
		SET @SEVERALCOLUMNS = 1;
		SET @CONSULTA = @CONSULTA + 'Month(PUPUORDER.OrderDate)  <= @MaxMonth ';
	  END
	SET @CONSULTA = @CONSULTA + ' GROUP BY PURSUPP.SupplierName ORDER BY QuantityOrders DESC;'
	print (@CONSULTA)
	EXEC SP_EXECUTESQL @consulta, N'@MinYear INT,@MaxYear INT,@MinMonth INT,@MaxMonth INT',@MinYear,@MaxYear,@MinMonth,@MaxMonth
;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------Excute------------------------------------------------------------------
--EXECUTE DBO.proceClienteGeneral '','','';
--EXECUTE DBO.proceClienteEspecifica 832;
---------------------------------------------------------
--EXECUTE DBO.proceProveedoresGeneral '','','';
--EXECUTE DBO.proceProveedorEspecifica 2;
---------------------------------------------------------
--EXECUTE DBO.proceInventariosGeneral '','',0;
--EXECUTE DBO.proceInventarioEspecifica 2;
---------------------------------------------------------
--EXECUTE DBO.proceVentasGeneral 0,'','','','',0,0;
--EXECUTE DBO.proceVentaEspecifica 34
 --------------------------------------------------------
--EXECUTE DBO.procePrimeroEstadistico '';
--EXECUTE DBO.proceSegundoEstadistico '';
--EXECUTE DBO.proceTerceroEstadistico 0,0,0,0;
--EXECUTE DBO.proceCuartoEstadistico 0,0,0,0;
--EXECUTE DBO.proceQuintoEstadistico 0,0,0,0;
--------------------------------------------------------------------Drop--------------------------------------------------------------------
--drop procedure DBO.proceClienteGeneral;
--drop procedure DBO.proceClienteEspecifica;
---------------------------------------------------------
--drop procedure DBO.proceProveedoresGeneral;
--drop procedure DBO.proceProveedorEspecifica;
---------------------------------------------------------
--drop procedure DBO.proceInventariosGeneral;
--drop procedure DBO.proceInventarioEspecifica;
---------------------------------------------------------
--drop procedure DBO.proceVentasGeneral;
--drop procedure DBO.proceVentaEspecifica;
---------------------------------------------------------
--drop procedure DBO.procePrimeroEstadistico;
--drop procedure DBO.proceSegundoEstadistico;
--drop procedure DBO.proceTerceroEstadistico;
--drop procedure DBO.proceCuartoEstadistico;
--drop procedure DBO.proceQuintoEstadistico;