/* Cleaning Data in SQL Queries


Select *
FROM test.dbo.NashvileHousing

--Format Date


Select SaleDateConverted,Convert(Date,SaleDate)
FROM test.dbo.NashvileHousing

Update test.dbo.NashvileHousing
SET SalesDate = Convert(Date,SaleDate)

--Alternavie way

Alter Table test.dbo.NashvileHousing
ADD SaleDateConverted Date

Update test.dbo.NashvileHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select *
FROM test.dbo.NashvileHousing


--Settle Property Address Data


Select *
FROM test.dbo.NashvileHousing
--Where PropertyAddress IS NULL
ORDER BY ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM test.dbo.NashvileHousing a
JOIN  test.dbo.NashvileHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM test.dbo.NashvileHousing a
JOIN  test.dbo.NashvileHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID]
WHERE a.PropertyAddress is NULL



-- Breaking out Address into Individual Columns( Address, City, States)


Select PropertyAddress
FROM test.dbo.NashvileHousing
--Where PropertyAddress IS NULL
--ORDER BY ParcelID

Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',' ,PropertyAddress)+1, LEN(PropertyAddress)) as Address
FROM test.dbo.NashvileHousing

Alter Table test.dbo.NashvileHousing
ADD PropertySplitAddress Nvarchar(255);

Update test.dbo.NashvileHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table test.dbo.NashvileHousing
ADD PropertySplitCity Nvarchar(255);

Update test.dbo.NashvileHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',' ,PropertyAddress)+1, LEN(PropertyAddress))

Select *
FROM test.dbo.NashvileHousing


Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3)
,PARSENAME(Replace(OwnerAddress, ',', '.'), 2)
,PARSENAME(Replace(OwnerAddress, ',', '.'),1 )
FROM test.dbo.NashvileHousing

Alter Table test.dbo.NashvileHousing
ADD OwnerSplitAddress Nvarchar(255);

Update test.dbo.NashvileHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table test.dbo.NashvileHousing
ADD OwnerSplitCity Nvarchar(255);

Update test.dbo.NashvileHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)



Alter Table test.dbo.NashvileHousing
ADD OwnerSplitState Nvarchar(255);

Update test.dbo.NashvileHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)

Select *
FROM test.dbo.NashvileHousing



--Set Y and No in 'Sold as vacanat' field



SELECT Distinct (Soldasvacant), COUNT (SoldasVacant)
FROM test.dbo.NashvileHousing
Group By SoldAsVacant
Order By SoldAsVacant

Select SoldAsVacant
, Case When SoldasVacant = 'Y' THEN 'Yes'
        When SoldasVacant = 'N' THEN 'NO'
		ELSE SoldasVacant
		END

FROM test.dbo.NashvileHousing

Update  test.dbo.NashvileHousing
SET SoldasVacant = Case When SoldasVacant = 'Y' THEN 'Yes'
        When SoldasVacant = 'N' THEN 'NO'
		ELSE SoldasVacant
		END

	
	
	--Remove Dublicates
	
	

  WITH RowNumCTE AS (
  Select *,
  ROW_NUMBER() OVER(
  PARTITION BY ParcelId, 
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY
			   UniqueID
			   )row_num
  FROM test.dbo.NashvileHousing

  )
  Select
  FROM  RowNumCTE
  WHERE row_num > 1
  
 

 -- Delete Unused Columns
 
 

Select *
FROM test.dbo.NashvileHousing

ALTER table test.dbo.NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER table test.dbo.NashvileHousing
DROP COLUMN SaleDate