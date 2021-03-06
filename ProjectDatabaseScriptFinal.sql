USE [BalloonShop]
GO
/****** Object:  FullTextCatalog [BalloonShopFullText]    Script Date: 2015-12-18 3:48:11 PM ******/
CREATE FULLTEXT CATALOG [BalloonShopFullText]WITH ACCENT_SENSITIVITY = ON
AS DEFAULT

GO
/****** Object:  StoredProcedure [dbo].[CatalogAddDepartment]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogAddDepartment]
(@DepartmentName nvarchar(50),
@DepartmentDescription nvarchar(1000))
AS
INSERT INTO Department (Name, Description)
VALUES (@DepartmentName, @DepartmentDescription)

GO
/****** Object:  StoredProcedure [dbo].[CatalogAssignProductToCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogAssignProductToCategory]
(@ProductID int, @CategoryID int)
AS
INSERT INTO ProductCategory (ProductID, CategoryID)
VALUES (@ProductID, @CategoryID)

GO
/****** Object:  StoredProcedure [dbo].[CatalogCreateCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogCreateCategory]
(@DepartmentID int,
@CategoryName nvarchar(50),
@CategoryDescription nvarchar(50))
AS
INSERT INTO Category (DepartmentID, Name, Description)
VALUES (@DepartmentID, @CategoryName, @CategoryDescription)

GO
/****** Object:  StoredProcedure [dbo].[CatalogCreateProduct]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogCreateProduct]
(@CategoryID INT,
 @ProductName NVARCHAR(50),
 @ProductDescription NVARCHAR(MAX),
 @Price MONEY,
 @Thumbnail NVARCHAR(50),
 @Image NVARCHAR(50),
 @PromoFront BIT,
 @PromoDept BIT)
AS
-- Declare a variable to hold the generated product ID
DECLARE @ProductID int
-- Create the new product entry

INSERT INTO Product 
    (Name, 
     Description, 
     Price, 
     Thumbnail, 
     Image,
     PromoFront, 
     PromoDept)
VALUES 
    (@ProductName, 
     @ProductDescription, 
     @Price, 
     @Thumbnail, 
     @Image,
     @PromoFront, 
     @PromoDept)
-- Save the generated product ID to a variable
SELECT @ProductID = @@Identity
-- Associate the product with a category
INSERT INTO ProductCategory (ProductID, CategoryID)
VALUES (@ProductID, @CategoryID)

GO
/****** Object:  StoredProcedure [dbo].[CatalogDeleteCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogDeleteCategory]
(@CategoryID int)
AS
DELETE FROM Category
WHERE CategoryID = @CategoryID

GO
/****** Object:  StoredProcedure [dbo].[CatalogDeleteDepartment]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogDeleteDepartment]
(@DepartmentID int)
AS
DELETE FROM Department
WHERE DepartmentID = @DepartmentID

GO
/****** Object:  StoredProcedure [dbo].[CatalogDeleteProduct]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogDeleteProduct]
(@ProductID int)
AS
DELETE FROM ShoppingCart WHERE ProductID=@ProductID
DELETE FROM ProductCategory WHERE ProductID=@ProductID
DELETE FROM Product where ProductID=@ProductID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetAllProductsInCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetAllProductsInCategory]
(@CategoryID INT)
AS
SELECT Product.ProductID, Name, Description, Price, Thumbnail, 
       Image, PromoDept, PromoFront
FROM Product INNER JOIN ProductCategory
  ON Product.ProductID = ProductCategory.ProductID
WHERE ProductCategory.CategoryID = @CategoryID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoriesInDepartment]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--missing procedures from 05-07


CREATE PROCEDURE [dbo].[CatalogGetCategoriesInDepartment]
(@DepartmentID INT)
AS
SELECT CategoryID, Name, Description
FROM Category
WHERE DepartmentID = @DepartmentID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoriesWithoutProduct]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetCategoriesWithoutProduct]
(@ProductID int)
AS
SELECT CategoryID, Name
FROM Category
WHERE CategoryID NOT IN
   (SELECT Category.CategoryID
    FROM Category INNER JOIN ProductCategory
    ON Category.CategoryID = ProductCategory.CategoryID
    WHERE ProductCategory.ProductID = @ProductID)

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoriesWithProduct]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetCategoriesWithProduct]
(@ProductID int)
AS
SELECT Category.CategoryID, Name
FROM Category INNER JOIN ProductCategory
ON Category.CategoryID = ProductCategory.CategoryID
WHERE ProductCategory.ProductID = @ProductID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetCategoryDetails]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetCategoryDetails]
(@CategoryID INT)
AS
SELECT DepartmentID, Name, Description
FROM Category
WHERE CategoryID = @CategoryID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetDepartmentDetails]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetDepartmentDetails]
(@DepartmentID INT)
AS
SELECT Name, Description
FROM Department
WHERE DepartmentID = @DepartmentID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetDepartments]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetDepartments] AS
SELECT DepartmentID, Name, Description
FROM Department

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductAttributeValues]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Create CatalogGetProductAttributeValues stored procedure
CREATE PROCEDURE [dbo].[CatalogGetProductAttributeValues]
(@ProductId INT)
AS
SELECT a.Name AS AttributeName,
       av.AttributeValueID, 
       av.Value AS AttributeValue
FROM AttributeValue av
INNER JOIN attribute a ON av.AttributeID = a.AttributeID
WHERE av.AttributeValueID IN
  (SELECT AttributeValueID
   FROM ProductAttributeValue
   WHERE ProductID = @ProductID)
ORDER BY a.Name;

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductDetails]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetProductDetails]
(@ProductID INT)
AS
SELECT Name, Description, Price, Thumbnail, Image, PromoFront, PromoDept
FROM Product
WHERE ProductID = @ProductID

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductRecommendations]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CatalogGetProductRecommendations]
(@ProductID INT,
@DescriptionLength INT)
AS
SELECT ProductID,
Name,
CASE WHEN LEN(Description) <= @DescriptionLength THEN Description
ELSE SUBSTRING(Description, 1, @DescriptionLength) + '...' END
AS Description
FROM Product
WHERE ProductID IN
(
SELECT TOP 5 od2.ProductID
FROM OrderDetail od1
JOIN OrderDetail od2 ON od1.OrderID = od2.OrderID
WHERE od1.ProductID = @ProductID AND od2.ProductID != @ProductID
GROUP BY od2.ProductID
ORDER BY COUNT(od2.ProductID) DESC
)

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductsInCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetProductsInCategory]
(@CategoryID INT,
@DescriptionLength INT,
@PageNumber INT,
@ProductsPerPage INT,
@HowManyProducts INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Products TABLE
(RowNumber INT,
 ProductID INT,
 Name NVARCHAR(50),
 Description NVARCHAR(MAX),
 Price MONEY,
 Thumbnail NVARCHAR(50),
 Image NVARCHAR(50),
 PromoFront bit,
 PromoDept bit)


-- populate the table variable with the complete list of products
INSERT INTO @Products
SELECT ROW_NUMBER() OVER (ORDER BY Product.ProductID),
       Product.ProductID, Name,
       CASE WHEN LEN(Description) <= @DescriptionLength THEN Description 
            ELSE SUBSTRING(Description, 1, @DescriptionLength) + '...' END 
       AS Description, Price, Thumbnail, Image, PromoFront, PromoDept 
FROM Product INNER JOIN ProductCategory
  ON Product.ProductID = ProductCategory.ProductID
WHERE ProductCategory.CategoryID = @CategoryID

-- return the total number of products using an OUTPUT variable
SELECT @HowManyProducts = COUNT(ProductID) FROM @Products

-- extract the requested page of products
SELECT ProductID, Name, Description, Price, Thumbnail,
       Image, PromoFront, PromoDept
FROM @Products
WHERE RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND RowNumber <= @PageNumber * @ProductsPerPage

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductsOnDeptPromo]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetProductsOnDeptPromo]
(@DepartmentID INT,
@DescriptionLength INT,
@PageNumber INT,
@ProductsPerPage INT,
@HowManyProducts INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Products TABLE
(RowNumber INT,
 ProductID INT,
 Name NVARCHAR(50),
 Description NVARCHAR(MAX),
 Price MONEY,
 Thumbnail NVARCHAR(50),
 Image NVARCHAR(50),
 PromoFront bit,
 PromoDept bit)

-- populate the table variable with the complete list of products
INSERT INTO @Products
SELECT ROW_NUMBER() OVER (ORDER BY ProductID) AS Row,
       ProductID, Name, SUBSTRING(Description, 1, @DescriptionLength)
+ '...' AS Description,
       Price, Thumbnail, Image, PromoFront, PromoDept
FROM
(SELECT DISTINCT Product.ProductID, Product.Name,
       CASE WHEN LEN(Product.Description) <= @DescriptionLength 
            THEN Product.Description 
            ELSE SUBSTRING(Product.Description, 1, @DescriptionLength) + '...' END 
       AS Description, Price, Thumbnail, Image, PromoFront, PromoDept 
  FROM Product INNER JOIN ProductCategory
                      ON Product.ProductID = ProductCategory.ProductID
              INNER JOIN Category
                      ON ProductCategory.CategoryID = Category.CategoryID
  WHERE Product.PromoDept = 1
   AND Category.DepartmentID = @DepartmentID
) AS ProductOnDepPr

-- return the total number of products using an OUTPUT variable
SELECT @HowManyProducts = COUNT(ProductID) FROM @Products

-- extract the requested page of products
SELECT ProductID, Name, Description, Price, Thumbnail,
       Image, PromoFront, PromoDept
FROM @Products
WHERE RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND RowNumber <= @PageNumber * @ProductsPerPage

GO
/****** Object:  StoredProcedure [dbo].[CatalogGetProductsOnFrontPromo]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogGetProductsOnFrontPromo]
(@DescriptionLength INT,
@PageNumber INT,
@ProductsPerPage INT,
@HowManyProducts INT OUTPUT)
AS

-- declare a new TABLE variable
DECLARE @Products TABLE
(RowNumber INT,
 ProductID INT,
 Name NVARCHAR(50),
 Description NVARCHAR(MAX),
 Price MONEY,
 Thumbnail NVARCHAR(50),
 Image NVARCHAR(50),
 PromoFront bit,
 PromoDept bit)


-- populate the table variable with the complete list of products
INSERT INTO @Products
SELECT ROW_NUMBER() OVER (ORDER BY Product.ProductID),
       ProductID, Name,
       CASE WHEN LEN(Description) <= @DescriptionLength THEN Description 
            ELSE SUBSTRING(Description, 1, @DescriptionLength) + '...' END 
       AS Description, Price, Thumbnail, Image, PromoFront, PromoDept
FROM Product
WHERE PromoFront = 1

-- return the total number of products using an OUTPUT variable
SELECT @HowManyProducts = COUNT(ProductID) FROM @Products

-- extract the requested page of products
SELECT ProductID, Name, Description, Price, Thumbnail,
       Image, PromoFront, PromoDept
FROM @Products
WHERE RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND RowNumber <= @PageNumber * @ProductsPerPage

GO
/****** Object:  StoredProcedure [dbo].[CatalogMoveProductToCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogMoveProductToCategory]
(@ProductID int, @OldCategoryID int, @NewCategoryID int)
AS
UPDATE ProductCategory
SET CategoryID = @NewCategoryID
WHERE CategoryID = @OldCategoryID
  AND ProductID = @ProductID

GO
/****** Object:  StoredProcedure [dbo].[CatalogRemoveProductFromCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogRemoveProductFromCategory]
(@ProductID int, @CategoryID int)
AS
DELETE FROM ProductCategory
WHERE CategoryID = @CategoryID AND ProductID = @ProductID

GO
/****** Object:  StoredProcedure [dbo].[CatalogUpdateCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogUpdateCategory]
(@CategoryID int,
@CategoryName nvarchar(50),
@CategoryDescription nvarchar(1000))
AS
UPDATE Category
SET Name = @CategoryName, Description = @CategoryDescription
WHERE CategoryID = @CategoryID

GO
/****** Object:  StoredProcedure [dbo].[CatalogUpdateDepartment]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogUpdateDepartment]
(@DepartmentID int,
@DepartmentName nvarchar(50),
@DepartmentDescription nvarchar(1000))
AS
UPDATE Department
SET Name = @DepartmentName, Description = @DepartmentDescription
WHERE DepartmentID = @DepartmentID

GO
/****** Object:  StoredProcedure [dbo].[CatalogUpdateProduct]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CatalogUpdateProduct]
(@ProductID INT,
 @ProductName VARCHAR(50),
 @ProductDescription VARCHAR(5000),
 @Price MONEY,
 @Thumbnail VARCHAR(50),
 @Image VARCHAR(50),
 @PromoFront BIT,
 @PromoDept BIT)
AS
UPDATE Product
SET Name = @ProductName,
    Description = @ProductDescription,
    Price = @Price,
    Thumbnail = @Thumbnail,
    Image = @Image,
    PromoFront = @PromoFront,
    PromoDept = @PromoDept
WHERE ProductID = @ProductID

GO
/****** Object:  StoredProcedure [dbo].[CreateOrder]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreateOrder] 
(@CartID char(36))
AS
/* Insert a new record INTo Orders */
DECLARE @OrderID INT
INSERT INTO Orders DEFAULT VALUES
/* Save the new Order ID */
SET @OrderID = @@IDENTITY
/* Add the order details to OrderDetail */
INSERT INTO OrderDetail 
     (OrderID, ProductID, ProductName, Quantity, UnitCost)
SELECT 
     @OrderID, Product.ProductID, Product.Name, 
     ShoppingCart.Quantity, Product.Price
FROM Product JOIN ShoppingCart
ON Product.ProductID = ShoppingCart.ProductID
WHERE ShoppingCart.CartID = @CartID
/* Clear the shopping cart */
DELETE FROM ShoppingCart
WHERE CartID = @CartID
/* Return the Order ID */
SELECT @OrderID

GO
/****** Object:  StoredProcedure [dbo].[GetShoppingCartRecommendations]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetShoppingCartRecommendations]
(@CartID CHAR(36),
 @DescriptionLength INT)
AS
--- Returns the product recommendations
SELECT ProductID,
       Name,
       SUBSTRING(Description, 1, @DescriptionLength) + '...' AS Description
FROM Product
WHERE ProductID IN
   (
   -- Returns the products that exist in a list of orders
   SELECT TOP 5 od1.ProductID AS Rank
   FROM OrderDetail od1 
     JOIN OrderDetail od2
       ON od1.OrderID=od2.OrderID
     JOIN ShoppingCart sp
       ON od2.ProductID = sp.ProductID
   WHERE sp.CartID = @CartID
        -- Must not include products that already exist in the visitor''s cart
      AND od1.ProductID NOT IN
      (
      -- Returns the products in the specified shopping cart
      SELECT ProductID 
      FROM ShoppingCart
      WHERE CartID = @CartID
      )
   -- Group the ProductID so we can calculate the rank
   GROUP BY od1.ProductID
   -- Order descending by rank
   ORDER BY COUNT(od1.ProductID) DESC
   )

GO
/****** Object:  StoredProcedure [dbo].[OrderGetDetails]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrderGetDetails]
(@OrderID INT)
AS
SELECT Orders.OrderID, 
       ProductID, 
       ProductName, 
       Quantity, 
       UnitCost, 
       Subtotal
FROM OrderDetail JOIN Orders
ON Orders.OrderID = OrderDetail.OrderID
WHERE Orders.OrderID = @OrderID

GO
/****** Object:  StoredProcedure [dbo].[OrderGetInfo]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrderGetInfo]
(@OrderID INT)
AS
SELECT OrderID, 
      (SELECT ISNULL(SUM(Subtotal), 0) FROM OrderDetail WHERE OrderID = @OrderID)        
       AS TotalAmount, 
       DateCreated, 
       DateShipped, 
       Verified, 
       Completed, 
       Canceled, 
       Comments, 
       CustomerName, 
       ShippingAddress, 
       CustomerEmail
FROM Orders
WHERE OrderID = @OrderID

GO
/****** Object:  StoredProcedure [dbo].[OrderMarkCanceled]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrderMarkCanceled]
(@OrderID INT)
AS
UPDATE Orders
SET Canceled = 1
WHERE OrderID = @OrderID

GO
/****** Object:  StoredProcedure [dbo].[OrderMarkCompleted]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrderMarkCompleted]
(@OrderID INT)
AS
UPDATE Orders
SET Completed = 1,
    DateShipped = GETDATE()
WHERE OrderID = @OrderID

GO
/****** Object:  StoredProcedure [dbo].[OrderMarkVerified]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrderMarkVerified]
(@OrderID INT)
AS
UPDATE Orders
SET Verified = 1
WHERE OrderID = @OrderID

GO
/****** Object:  StoredProcedure [dbo].[OrdersGetByDate]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrdersGetByDate] 
(@StartDate SMALLDATETIME,
 @EndDate SMALLDATETIME)
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE DateCreated BETWEEN @StartDate AND @EndDate
ORDER BY DateCreated DESC

GO
/****** Object:  StoredProcedure [dbo].[OrdersGetByRecent]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrdersGetByRecent] 
(@Count smallINT)
AS
-- Set the number of rows to be returned
SET ROWCOUNT @Count
-- Get list of orders
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
ORDER BY DateCreated DESC
-- Reset rowcount value
SET ROWCOUNT 0

GO
/****** Object:  StoredProcedure [dbo].[OrdersGetUnverifiedUncanceled]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrdersGetUnverifiedUncanceled]
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE Verified=0 AND Canceled=0
ORDER BY DateCreated DESC

GO
/****** Object:  StoredProcedure [dbo].[OrdersGetVerifiedUncompleted]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrdersGetVerifiedUncompleted]
AS
SELECT OrderID, DateCreated, DateShipped, 
       Verified, Completed, Canceled, CustomerName
FROM Orders
WHERE Verified=1 AND Completed=0
ORDER BY DateCreated DESC

GO
/****** Object:  StoredProcedure [dbo].[OrderUpdate]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrderUpdate]
(@OrderID INT,
 @DateCreated SMALLDATETIME,
 @DateShipped SMALLDATETIME = NULL,
 @Verified BIT,
 @Completed BIT,
 @Canceled BIT,
 @Comments VARCHAR(200),
 @CustomerName VARCHAR(50),
 @ShippingAddress VARCHAR(200),
 @CustomerEmail VARCHAR(50))
AS
UPDATE Orders
SET DateCreated=@DateCreated,
    DateShipped=@DateShipped,
    Verified=@Verified,
    Completed=@Completed,
    Canceled=@Canceled,
    Comments=@Comments,
    CustomerName=@CustomerName,
    ShippingAddress=@ShippingAddress,
    CustomerEmail=@CustomerEmail
WHERE OrderID = @OrderID

GO
/****** Object:  StoredProcedure [dbo].[SearchCatalog]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchCatalog] 
(@DescriptionLength INT,
 @PageNumber TINYINT,
 @ProductsPerPage TINYINT,
 @HowManyResults INT OUTPUT,
 @AllWords BIT,
 @Word1 NVARCHAR(15) = NULL,
 @Word2 NVARCHAR(15) = NULL,
 @Word3 NVARCHAR(15) = NULL,
 @Word4 NVARCHAR(15) = NULL,
 @Word5 NVARCHAR(15) = NULL)
AS

/* @NecessaryMatches needs to be 1 for any-word searches and
   the number of words for all-words searches */
DECLARE @NecessaryMatches INT
SET @NecessaryMatches = 1
IF @AllWords = 1 
  SET @NecessaryMatches =
    CASE WHEN @Word1 IS NULL THEN 0 ELSE 1 END + 
    CASE WHEN @Word2 IS NULL THEN 0 ELSE 1 END + 
    CASE WHEN @Word3 IS NULL THEN 0 ELSE 1 END +
    CASE WHEN @Word4 IS NULL THEN 0 ELSE 1 END +
    CASE WHEN @Word5 IS NULL THEN 0 ELSE 1 END;

/* Create the table variable that will contain the search results */
DECLARE @Matches TABLE
([Key] INT NOT NULL,
 Rank INT NOT NULL)

-- Save matches for the first word
IF @Word1 IS NOT NULL
  INSERT INTO @Matches
  EXEC SearchWord @Word1

-- Save the matches for the second word
IF @Word2 IS NOT NULL
  INSERT INTO @Matches
  EXEC SearchWord @Word2

-- Save the matches for the third word
IF @Word3 IS NOT NULL
  INSERT INTO @Matches
  EXEC SearchWord @Word3

-- Save the matches for the fourth word
IF @Word4 IS NOT NULL
  INSERT INTO @Matches
  EXEC SearchWord @Word4

-- Save the matches for the fifth word
IF @Word5 IS NOT NULL
  INSERT INTO @Matches
  EXEC SearchWord @Word5

-- Calculate the IDs of the matching products
DECLARE @Results TABLE
(RowNumber INT,
 [KEY] INT NOT NULL,
 Rank INT NOT NULL)

-- Obtain the matching products 
INSERT INTO @Results
SELECT ROW_NUMBER() OVER (ORDER BY COUNT(M.Rank) DESC),
       M.[KEY], SUM(M.Rank) AS TotalRank
FROM @Matches M
GROUP BY M.[KEY]
HAVING COUNT(M.Rank) >= @NecessaryMatches

-- return the total number of results using an OUTPUT variable
SELECT @HowManyResults = COUNT(*) FROM @Results

-- populate the table variable with the complete list of products
SELECT Product.ProductID, Name,
       CASE WHEN LEN(Description) <= @DescriptionLength THEN Description 
            ELSE SUBSTRING(Description, 1, @DescriptionLength) + '...' END 
       AS Description, Price, Thumbnail, Image, PromoFront, PromoDept 
FROM Product 
INNER JOIN @Results R
ON Product.ProductID = R.[KEY]
WHERE R.RowNumber > (@PageNumber - 1) * @ProductsPerPage
  AND R.RowNumber <= @PageNumber * @ProductsPerPage
ORDER BY R.Rank DESC

GO
/****** Object:  StoredProcedure [dbo].[SearchWord]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchWord] (@Word NVARCHAR(50))
AS

SET @Word = 'FORMSOF(INFLECTIONAL, "' + @Word + '")'

SELECT COALESCE(NameResults.[KEY], DescriptionResults.[KEY]) AS [KEY],
       ISNULL(NameResults.Rank, 0) * 3 + 
       ISNULL(DescriptionResults.Rank, 0) AS Rank 
FROM 
  CONTAINSTABLE(Product, Name, @Word, 
                LANGUAGE 'English') AS NameResults
  FULL OUTER JOIN
  CONTAINSTABLE(Product, Description, @Word, 
                LANGUAGE 'English') AS DescriptionResults
  ON NameResults.[KEY] = DescriptionResults.[KEY]

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartAddItem]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ShoppingCartAddItem]
(@CartID char(36),
 @ProductID int,
 @Attributes nvarchar(1000))
AS
IF EXISTS
        (SELECT CartID
         FROM ShoppingCart
         WHERE ProductID = @ProductID AND CartID = @CartID)
    UPDATE ShoppingCart
    SET Quantity = Quantity + 1
    WHERE ProductID = @ProductID AND CartID = @CartID
ELSE
    IF EXISTS (SELECT Name FROM Product WHERE ProductID=@ProductID)
        INSERT INTO ShoppingCart (CartID, ProductID, Attributes, Quantity, DateAdded)
        VALUES (@CartID, @ProductID, @Attributes, 1, GETDATE())

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartCountOldCarts]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartCountOldCarts]
(@Days smallint)
AS
SELECT COUNT(CartID)
FROM ShoppingCart
WHERE CartID IN
(SELECT CartID
FROM ShoppingCart
GROUP BY CartID
HAVING MIN(DATEDIFF(dd,DateAdded,GETDATE())) >= @Days)

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartDeleteOldCarts]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartDeleteOldCarts]
(@Days smallint)
AS
DELETE FROM ShoppingCart
WHERE CartID IN
(SELECT CartID
FROM ShoppingCart
GROUP BY CartID
HAVING MIN(DATEDIFF(dd,DateAdded,GETDATE())) >= @Days)

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartGetItems]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartGetItems]
(@CartID char(36))
AS
SELECT Product.ProductID, Product.Name, ShoppingCart.Attributes, Product.Price, ShoppingCart.Quantity,Product.Price * ShoppingCart.Quantity AS Subtotal
FROM ShoppingCart INNER JOIN Product
ON ShoppingCart.ProductID = Product.ProductID
WHERE ShoppingCart.CartID = @CartID

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartGetTotalAmount]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartGetTotalAmount]
(@CartID char(36))
AS
SELECT ISNULL(SUM(Product.Price * ShoppingCart.Quantity), 0)
FROM ShoppingCart INNER JOIN Product
ON ShoppingCart.ProductID = Product.ProductID
WHERE ShoppingCart.CartID = @CartID

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartRemoveItem]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ShoppingCartRemoveItem]
(@CartID char(36),
 @ProductID int)
AS
DELETE FROM ShoppingCart
WHERE CartID = @CartID and ProductID = @ProductID

GO
/****** Object:  StoredProcedure [dbo].[ShoppingCartUpdateItem]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ShoppingCartUpdateItem]
(@CartID char(36),
 @ProductID int,
 @Quantity int)
AS
IF @Quantity <= 0
  EXEC ShoppingCartRemoveItem @CartID, @ProductID
ELSE
  UPDATE ShoppingCart
  SET Quantity = @Quantity, DateAdded = GETDATE()
  WHERE ProductID = @ProductID AND CartID = @CartID

GO
/****** Object:  StoredProcedure [dbo].[updatePrice]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[updatePrice] (@priceInc money)
as
begin
update Product set Price=Price+@priceInc;
end
GO
/****** Object:  UserDefinedFunction [dbo].[calcPrice]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[calcPrice] (@prodID int) returns money
as
begin
declare @currentPrice money;
declare @totPrice money;
select @currentPrice=Price from Product where ProductID=@prodID;
set @totPrice = @currentPrice+@currentPrice*0.13;
return @totPrice;
end
GO
/****** Object:  Table [dbo].[Attribute]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attribute](
	[AttributeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AttributeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AttributeValue]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeValue](
	[AttributeValueID] [int] IDENTITY(1,1) NOT NULL,
	[AttributeID] [int] NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AttributeValueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Category_1] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Department]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitCost] [money] NOT NULL,
	[Subtotal]  AS ([Quantity]*[UnitCost]),
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orders]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[DateCreated] [smalldatetime] NOT NULL CONSTRAINT [DF_Orders_DateCreated]  DEFAULT (getdate()),
	[DateShipped] [smalldatetime] NULL,
	[Verified] [bit] NOT NULL CONSTRAINT [DF_Orders_Verified]  DEFAULT ((0)),
	[Completed] [bit] NOT NULL CONSTRAINT [DF_Orders_Completed]  DEFAULT ((0)),
	[Canceled] [bit] NOT NULL CONSTRAINT [DF_Orders_Canceled]  DEFAULT ((0)),
	[Comments] [nvarchar](1000) NULL,
	[CustomerName] [nvarchar](50) NULL,
	[CustomerEmail] [nvarchar](50) NULL,
	[ShippingAddress] [nvarchar](500) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[Price] [money] NOT NULL,
	[Thumbnail] [nvarchar](50) NULL,
	[Image] [nvarchar](50) NULL,
	[PromoFront] [bit] NOT NULL,
	[PromoDept] [bit] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductAttributeValue]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductAttributeValue](
	[ProductID] [int] NOT NULL,
	[AttributeValueID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[AttributeValueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductCategory]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategory](
	[ProductID] [int] NOT NULL,
	[CategoryID] [int] NOT NULL,
 CONSTRAINT [PK_ProductCategory] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductsAbove100]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductsAbove100](
	[ProductID] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[Price] [money] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ShoppingCart](
	[CartID] [char](36) NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Attributes] [nvarchar](1000) NULL,
	[DateAdded] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_ShoppingCart] PRIMARY KEY CLUSTERED 
(
	[CartID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[ProdsInCats]    Script Date: 2015-12-18 3:48:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ProdsInCats]
AS
SELECT dbo.Product.ProductID, dbo.Product.Name, dbo.Product.Description, dbo.Product.Price, dbo.Product.Thumbnail, dbo.ProductCategory.CategoryID
FROM   dbo.Product INNER JOIN
            dbo.ProductCategory ON dbo.Product.ProductID = dbo.ProductCategory.ProductID

GO
SET IDENTITY_INSERT [dbo].[Attribute] ON 

INSERT [dbo].[Attribute] ([AttributeID], [Name]) VALUES (1, N'Color')
SET IDENTITY_INSERT [dbo].[Attribute] OFF
SET IDENTITY_INSERT [dbo].[AttributeValue] ON 

INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (1, 1, N'White')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (2, 1, N'Black')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (3, 1, N'Red')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (4, 1, N'Orange')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (5, 1, N'Yellow')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (6, 1, N'Green')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (7, 1, N'Blue')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (8, 1, N'Indigo')
INSERT [dbo].[AttributeValue] ([AttributeValueID], [AttributeID], [Value]) VALUES (9, 1, N'Purple')
SET IDENTITY_INSERT [dbo].[AttributeValue] OFF
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([CategoryID], [DepartmentID], [Name], [Description]) VALUES (1, 1, N'Men''s Running', N'Here is our brand of running shoes')
INSERT [dbo].[Category] ([CategoryID], [DepartmentID], [Name], [Description]) VALUES (2, 1, N'Men''s Casual', N'Show off your casual Style!!')
INSERT [dbo].[Category] ([CategoryID], [DepartmentID], [Name], [Description]) VALUES (3, 1, N'Men''s Winter Boots', N'Keep your foots warm!!')
INSERT [dbo].[Category] ([CategoryID], [DepartmentID], [Name], [Description]) VALUES (4, 2, N'Women''s Running', N'Here is our brand of running shoes')
INSERT [dbo].[Category] ([CategoryID], [DepartmentID], [Name], [Description]) VALUES (5, 2, N'Women''s Casual', N'Show off your casual Style!!')
INSERT [dbo].[Category] ([CategoryID], [DepartmentID], [Name], [Description]) VALUES (6, 2, N'Women''s Winter Boots', N'Perfect for special events')
SET IDENTITY_INSERT [dbo].[Category] OFF
SET IDENTITY_INSERT [dbo].[Department] ON 

INSERT [dbo].[Department] ([DepartmentID], [Name], [Description]) VALUES (1, N'Men''s', N'Shoes for men including children')
INSERT [dbo].[Department] ([DepartmentID], [Name], [Description]) VALUES (2, N'Women''s', N'Shoes for women including children')
SET IDENTITY_INSERT [dbo].[Department] OFF
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (1, 4, N'Today, Tomorrow & Forever', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (2, 1, N'I Love You (Simon Elvin)', 2, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (2, 5, N'Smiley Heart Red Balloon', 5, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (3, 1, N'I Love You (Simon Elvin)', 2, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (3, 24, N'Birthday Star Balloon', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (4, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (4, 2, N'Elvis Hunka Burning Love', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (4, 4, N'Today, Tomorrow & Forever', 2, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (4, 5, N'Smiley Heart Red Balloon', 2, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (5, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (5, 4, N'Today, Tomorrow & Forever', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (6, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (6, 24, N'Birthday Star Balloon', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (7, 2, N'Elvis Hunka Burning Love', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (7, 25, N'Tweety Stars', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (7, 40, N'Rugrats Tommy & Chucky', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (8, 14, N'Love Rose', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (8, 22, N'I''m Younger Than You', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (9, 4, N'Today, Tomorrow & Forever', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (10, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (10, 4, N'Today, Tomorrow & Forever', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (10, 10, N'I Can''t Get Enough of You Baby', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (11, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (12, 3, N'Funny Love', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (12, 57, N'Crystal Rose Silver', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (12, 58, N'Crystal Rose Gold', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (13, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (13, 23, N'Birthday Balloon', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (14, 2, N'Elvis Hunka Burning Love', 2, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (14, 5, N'Smiley Heart Red Balloon', 31, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (14, 63, N'Joanne''s birthday balloon', 1, 23.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (17, 1, N'I Love You (Simon Elvin)', 1, 12.4900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (17, 7, N'Smiley Kiss Red Balloon', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (17, 10, N'I Can''t Get Enough of You Baby', 1, 12.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (18, 1, N'Duramo Elite', 1, 71.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (19, 15, N'Atwood', 1, 79.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (19, 40, N'Character V', 1, 79.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (20, 1, N'Duramo Elite', 2, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (21, 1, N'Duramo Elite', 1, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (22, 1, N'Duramo Elite', 1, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (22, 26, N'Briggs Mid Waterproof', 1, 175.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (23, 1, N'Duramo Elite', 1, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (23, 14, N'Atwood', 1, 79.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (23, 26, N'Briggs Mid Waterproof', 1, 175.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (23, 30, N'Classics Ultra High', 1, 151.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (24, 1, N'Duramo Elite', 1, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (24, 14, N'Atwood', 1, 79.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (24, 26, N'Briggs Mid Waterproof', 1, 175.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (24, 30, N'Classics Ultra High', 1, 151.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (25, 1, N'Duramo Elite', 1, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (25, 4, N'X Ultra 2 Gtx', 1, 169.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (26, 1, N'Duramo Elite', 4, 111.9800)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (26, 4, N'X Ultra 2 Gtx', 1, 169.9900)
INSERT [dbo].[OrderDetail] ([OrderID], [ProductID], [ProductName], [Quantity], [UnitCost]) VALUES (26, 30, N'Classics Ultra High', 1, 151.9800)
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (1, CAST(N'2010-11-25 16:48:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (2, CAST(N'2010-11-26 07:05:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (3, CAST(N'2010-11-26 08:38:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (4, CAST(N'2010-11-26 11:59:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (5, CAST(N'2010-11-30 07:15:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (6, CAST(N'2010-11-30 07:17:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (7, CAST(N'2010-11-30 07:21:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (8, CAST(N'2010-11-30 11:18:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (9, CAST(N'2010-11-30 11:20:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (10, CAST(N'2010-11-30 11:39:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (11, CAST(N'2011-03-18 16:21:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (12, CAST(N'2011-03-18 16:23:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (13, CAST(N'2012-03-15 16:38:00' AS SmallDateTime), CAST(N'2011-05-15 08:34:00' AS SmallDateTime), 0, 0, 1, N'', N'', N'', N'')
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (14, CAST(N'2012-03-23 12:39:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (15, CAST(N'2012-03-23 12:39:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (16, CAST(N'2012-03-23 12:40:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (17, CAST(N'2012-03-23 12:43:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (18, CAST(N'2015-12-02 14:01:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (19, CAST(N'2015-12-10 13:37:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (20, CAST(N'2015-12-10 13:47:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (21, CAST(N'2015-12-10 13:48:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (22, CAST(N'2015-12-18 15:19:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (23, CAST(N'2015-12-18 15:37:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (24, CAST(N'2015-12-18 15:39:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (25, CAST(N'2015-12-18 15:41:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [DateCreated], [DateShipped], [Verified], [Completed], [Canceled], [Comments], [CustomerName], [CustomerEmail], [ShippingAddress]) VALUES (26, CAST(N'2015-12-18 15:45:00' AS SmallDateTime), NULL, 0, 0, 0, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Orders] OFF
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (1, N'Duramo Elite', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 111.9800, N'281020086-03.jpg', N'281020086-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (2, N'Sequence', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 95.9800, N'281021139-03.jpg', N'281021139-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (3, N'Annex', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 167.9800, N'284221001-03.jpg', N'284221001-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (4, N'X Ultra 2 Gtx', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 169.9900, N'284101034-03.jpg', N'284101034-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (5, N'Guid 8', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 159.9800, N'281020086-033.jpg', N'281020086-033.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (6, N'Salida Mid', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 199.9900, N'184201076-03.jpg', N'184201076-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (7, N'Siren Sport', N'These Siren Sport hikers off support and protection for your feet. They feature secure lace-up system and mesh upper for ventilation.', 159.9900, N'184614034-03.jpg', N'184614034-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (8, N'Flurecein', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 183.8800, N'184201077-03.jpg', N'184201077-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (9, N'Gel Flux X2', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 143.9800, N'181601143-03.jpg', N'181601143-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (10, N'Redmond Waterproof Hiker Brown', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 147.8800, N'184201071-03.jpg', N'184201071-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (11, N'Targhee', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 167.9800, N'184201083-03.jpg', N'184201083-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (12, N'Albany Front Lace', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 143.9800, N'132601076-03.jpg', N'132601076-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (13, N'Kordel', N'Step out in style with these men’s Helly Hansen Kordel casual lace-up trainers. Made of supple leather, these low-top trainers have breathable textile lining and grippy rubber outsole with flat heel design.', 149.9900, N'231201156-03.jpg', N'231201156-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (14, N'Atwood', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 79.9800, N'299501024-03.jpg', N'299501024-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (15, N'Atwood', N'Tell someone how special he or she is with this lovely heart-shaped balloon with a cute bear holding a flower.', 79.9800, N'299680024-03.jpg', N'299680024-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (16, N'Core Hi', N'Converse. Men''s high cut casual shoes with lace-up closure, canvas upper and rubber outsole. Available in Red, Navy, White and Grey Canvas. Sizes 7-13 Full D.', 87.9800, N'291480502-03.jpg', N'291480502-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (17, N'Star Players Canvas', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 66.9800, N'291017022-03.jpg', N'291017022-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (18, N'A/O 2 Eye Boat Shoe', N'Make your style statement with these Sperry A/O 2 Eye boat shoes that showcase leather upper, lace-up closure with two-pairs of metal eyelets and tonal stitching details.', 155.0000, N'135211803-03.jpg', N'135211803-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (19, N'Bow Ballerina', N'These exquisite Sam Edelman Bow Ballerina casuals come with fine leather upper, adorned with toe lace and synthetic sole.', 175.0000, N'135110177-03.jpg', N'135110177-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (20, N'Dream Catcher Crochet', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 83.9800, N'136301099-03.jpg', N'136301099-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (21, N'Dream Catcher Crochet', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 83.9800, N'136101099-03.jpg', N'136101099-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (22, N'Grants Flat', N'Acquire a rustic touch with these teen women’s Blowfish Grants casual flats. Made of fine fabric, these casual flats come with padded sock that give reliable comfort with each step.', 71.9800, N'136601130-03.jpg', N'136601130-03.jpg', 1, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (23, N'Stinson', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 179.9900, N'236201245-03.jpg', N'236201245-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (24, N'Fortani Lace-up Black', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 184.9900, N'261101093-03.jpg', N'261101093-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (25, N'Remsen', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 169.9900, N'236201244-03.jpg', N'236201244-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (26, N'Briggs Mid Waterproof', N'Offering comfort and performance, these Keen hiking boots feature suede upper, protective toe cap, compression molded EVA midsole and non-marking rubber outsole.', 175.9800, N'265201012-03.jpg', N'265201012-03.jpg', 1, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (27, N'Knaster 3 Boot', N'With the ultimate rugged look & built for the toughest terrain, these Helly Hansen Knaster 3 Boot feature leather upper, waterproof exterior and cushioned interior.', 167.9800, N'265110775-03.jpg', N'265110775-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (28, N'Knaster 3 Boot', N'With the ultimate rugged look & built for the toughest terrain, these Helly Hansen Knaster 3 Boot feature leather upper, waterproof exterior and cushioned interior.', 167.9800, N'265211775-03.jpg', N'265211775-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (29, N'Gataga', N'Trekking up a rough terrain or braving stormy weather becomes easy with the BD Gataga. They featuring waterproof leather upper, Eva midsole, and high grip rubber outsole, these boots are ready for any outdoor activity.', 175.9800, N'265218058-03.jpg', N'265218058-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (30, N'Classics Ultra High', N'Keep your feet warm and cozy with these Classics Ultra High boots that feature waterproof upper, knee high design and cold rating of -40C.', 151.9800, N'268101002-03.jpg', N'268101002-03.jpg', 1, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (31, N'Cagney Pt Lace', N'Make a solid fashion statement with these men’s Stacy Adams Cagney casual boots that feature leather upper, contrast stitching details, leather lining and burnished toe accent.', 149.9800, N'236201051-03.jpg', N'236201051-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (32, N'Gataga', N'Hike in these Helly Hansen boots that feature waterproof construction, leather upper, fleece ankle, Cambrelle moisture wicking textile lining and rubber lug sole.', 175.9800, N'265110058-03.jpg', N'265110058-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (33, N'Nolan', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 179.9900, N'169201286-03.jpg', N'169201286-03.jpg', 1, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (34, N'Haddie', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 169.9900, N'163101245-03.jpg', N'163101245-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (35, N'Zela - Online Exclusive', N'Casual Bootie with stap and buckle detailing and a soft burnished finish to the upper. Featuring the "All-Thru Comfort" system from Natural Soul - fully cushioned in soles, padded uppers and soft flexible out soles for 360 degrees of comfort.', 155.9900, N'164661653-03.jpg', N'164661653-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (36, N'Darena - Online Exclusive', N'Sporty and casual ankle bootie in burnished suede. Features the N5 comfort system within - Flexible, light weight, Ergonomically balanced constructions with soft cushioning insoles and breathable linings', 204.9900, N'165261479-03.jpg', N'165261479-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (37, N'Renna - Online Exclusive', N'Thinking of someone? Let them know with this thoughtful heart-shaped balloon with flowers in the background.', 187.9900, N'161161318-03.jpg', N'161161318-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (38, N'Talayna - Online Exclusive', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 174.9900, N'161161326-03.jpg', N'161161326-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (39, N'Renna - Online Exclusive', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 187.9900, N'161261318-03.jpg', N'161261318-03.jpg', 1, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (40, N'Character V', N'These boys'' athletic DC shoes feature velcro closure, padded collar and rubber outsole.', 79.9800, N'892615135-03.jpg', N'892615135-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (41, N'Hyperfast', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 83.9800, N'891101060-03.jpg', N'891101060-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (42, N'Atwood', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 75.9800, N'891201606-03.jpg', N'891201606-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (43, N'Allred', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 83.9800, N'891501026-03.jpg', N'891501026-03.jpg', 1, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (44, N'Mecca Bunkhouse', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 82.3800, N'853200001-03.jpg', N'853200001-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (45, N'23Rd Mid - Excluded from Promotion', N'These Bogs ankle boots come with breathable, abrasion-resistant tech-mesh upper, pull-handles, and lace-up closure.', 87.8800, N'861125022-03.jpg', N'861125022-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (46, N'CS-52106', N'Featuring adjustable cuff, waterproof upper, these youth boys'' winter boots from ts keep little feet warm in winter.', 72.9800, N'863101018-03.jpg', N'863101018-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (47, N'Rallye (Szg) Black/Red', N'Youth boys'' winter boots with double Velcro strap, graphic detail and winter protection.', 75.9800, N'863101033-03.jpg', N'863101033-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (48, N'Rg Lido Iii', N'These vivid and cute youth girls'' Roxy RG Lido III dress shoes feature stitched moc toe construction, elastic goring, canvas lining, and padded footbed.', 66.3900, N'857401064-03.jpg', N'857401064-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (49, N'Betty', N'Adorn your feet with these attractive youth girls'' Jewels Betty sandals. Decorated with shimmering stones, these T-strapped sandals have buckle closure for easy on/off and a customized fit.', 67.9900, N'856001048-03.jpg', N'856001048-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (50, N'Fiona', N'With glittering upper, cheetah print lining and dainty bow at toe, these youth girls'' ballerina flats look cute on your little princess'' feet.', 81.9800, N'856828075-03.jpg', N'856828075-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (51, N'Asher V', N'Part of the Vans x Hello Kitty® Collection, these Vans Asher shoes features a printed Hello Kitty® canvas upper, vulcanized construction and Vans signature rubber waffle outsole.', 65.7800, N'826401025-03.jpg', N'826401025-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (52, N'Emmy', N'Step out in these pretty youth girls'' Paris Blues Emmy wedges. Adorned with beautiful studded jewels, these wedges have stretch elastic goring for easy entry and stylish signature printed insole.', 66.9800, N'856001047-03.jpg', N'856001047-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (53, N'K Button Black - Excluded from Promotion', N'Youth girls'' suede boots with button loop closure, shearling lining trim and lightweight construction.', 171.9800, N'868111021-03.jpg', N'868111021-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (54, N'K Button Chestnut - Excluded from Promotion', N'Youth girls'' boots with suede upper, Ugg logo, lightweight construction and shearling lining.', 171.9800, N'868313021-03.jpg', N'868313021-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (55, N'5251 K Classic Black', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 204.9900, N'868111022-03.jpg', N'868111022-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (56, N'K Classic Chestnut - Excluded from Promotion', N'Keep your child''s feet cozy and comfy in these youth girls'' suede boots from Ugg that are styled with outer seam, shear lining and foam EVA outsole.', 199.9900, N'868313022-03.jpg', N'868313022-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (57, N'Joan Of Arctic', N'Youth girls'' winter boots with faux fur cuff, lace up closure, rubber shell and -40C cold rating.', 169.9900, N'868914074-03.jpg', N'868914074-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (58, N'Joan of Arctic', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 169.9900, N'868604074-03.jpg', N'868604074-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (59, N'Jb010 Buckle', N'Enjoy the rainy season in these youth girls'' rain boots', 54.9800, N'867111042-03.jpg', N'867111042-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (60, N'Flowers', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 56.7800, N'867901054-03.jpg', N'867901054-03.jpg', 0, 1)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (61, N'Cats', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 54.9800, N'846401017-03.jpg', N'846401017-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (62, N'Midas Misses', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 56.7800, N'867401055-03.jpg', N'867401055-03.jpg', 0, 0)
INSERT [dbo].[Product] ([ProductID], [Name], [Description], [Price], [Thumbnail], [Image], [PromoFront], [PromoDept]) VALUES (63, N'Hot Paws', N'At The ShoeShop, we believe style shouldn’t demand a huge investment of time or money. That’s why our footwear feels as good as it looks. We strive to ensure your shopping experience is easy on your wallet, and your schedule, by delivering fashion and value to everyone in your household. The ShoeShop. Great brands. Smart Prices', 87.9800, N'868901100-03.jpg', N'868901100-03.jpg', 1, 0)
SET IDENTITY_INSERT [dbo].[Product] OFF
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (1, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (2, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (3, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (4, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (5, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (6, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (7, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (8, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (9, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (10, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (11, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 1)
GO
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (12, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (13, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (14, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (15, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (16, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (17, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (18, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (19, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (20, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (21, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (22, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 2)
GO
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (23, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (24, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (25, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (26, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (27, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (28, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (29, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (30, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (31, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (32, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (33, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 3)
GO
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (34, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (35, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (36, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (37, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (38, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (39, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (40, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (41, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (42, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (43, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (44, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 4)
GO
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (45, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (46, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (47, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (48, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (49, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (50, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (51, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (52, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (53, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (54, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (55, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 5)
GO
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (56, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (57, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (58, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (59, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (60, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (61, 9)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 1)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 2)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 3)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 4)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 5)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 6)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 7)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 8)
INSERT [dbo].[ProductAttributeValue] ([ProductID], [AttributeValueID]) VALUES (62, 9)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (1, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (2, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (3, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (4, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (5, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (6, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (7, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (8, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (9, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (10, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (11, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (12, 4)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (13, 2)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (14, 2)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (15, 2)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (16, 2)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (17, 2)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (18, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (19, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (20, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (21, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (22, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (23, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (24, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (25, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (26, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (27, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (28, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (29, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (30, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (31, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (32, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (33, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (34, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (35, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (36, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (37, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (38, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (39, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (40, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (41, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (42, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (43, 1)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (44, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (45, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (46, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (47, 3)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (48, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (49, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (50, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (51, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (52, 5)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (53, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (54, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (55, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (56, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (57, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (58, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (59, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (60, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (61, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (62, 6)
INSERT [dbo].[ProductCategory] ([ProductID], [CategoryID]) VALUES (63, 6)
INSERT [dbo].[ProductsAbove100] ([ProductID], [Name], [Price]) VALUES (65, N'asdasd', 150.0000)
INSERT [dbo].[ProductsAbove100] ([ProductID], [Name], [Price]) VALUES (66, N'edede', 200.0000)
INSERT [dbo].[ProductsAbove100] ([ProductID], [Name], [Price]) VALUES (67, N'Nike', 140.0000)
INSERT [dbo].[ShoppingCart] ([CartID], [ProductID], [Quantity], [Attributes], [DateAdded]) VALUES (N'a6ac31fb-ef2a-4e38-b3c1-7904d5d6a7c9', 5, 1, N'attributes', CAST(N'2012-03-15 16:39:00' AS SmallDateTime))
ALTER TABLE [dbo].[AttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_AttributeValue_Attribute] FOREIGN KEY([AttributeID])
REFERENCES [dbo].[Attribute] ([AttributeID])
GO
ALTER TABLE [dbo].[AttributeValue] CHECK CONSTRAINT [FK_AttributeValue_Attribute]
GO
ALTER TABLE [dbo].[Category]  WITH CHECK ADD  CONSTRAINT [FK_Category_Department] FOREIGN KEY([DepartmentID])
REFERENCES [dbo].[Department] ([DepartmentID])
GO
ALTER TABLE [dbo].[Category] CHECK CONSTRAINT [FK_Category_Department]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetail_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OrderDetail_Orders]
GO
ALTER TABLE [dbo].[ProductAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttributeValue_AttributeValue] FOREIGN KEY([AttributeValueID])
REFERENCES [dbo].[AttributeValue] ([AttributeValueID])
GO
ALTER TABLE [dbo].[ProductAttributeValue] CHECK CONSTRAINT [FK_ProductAttributeValue_AttributeValue]
GO
ALTER TABLE [dbo].[ProductAttributeValue]  WITH CHECK ADD  CONSTRAINT [FK_ProductAttributeValue_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductAttributeValue] CHECK CONSTRAINT [FK_ProductAttributeValue_Product]
GO
ALTER TABLE [dbo].[ProductCategory]  WITH CHECK ADD  CONSTRAINT [FK_ProductCategory_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[ProductCategory] CHECK CONSTRAINT [FK_ProductCategory_Category]
GO
ALTER TABLE [dbo].[ProductCategory]  WITH CHECK ADD  CONSTRAINT [FK_ProductCategory_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ProductCategory] CHECK CONSTRAINT [FK_ProductCategory_Product]
GO
ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCart_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[ShoppingCart] CHECK CONSTRAINT [FK_ShoppingCart_Product]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Product"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 156
               Right = 250
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "ProductCategory"
            Begin Extent = 
               Top = 9
               Left = 307
               Bottom = 114
               Right = 500
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ProdsInCats'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ProdsInCats'
GO
