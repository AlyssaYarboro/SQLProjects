-- Cleaning Data in SQL Queries

Select *
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing




-- Changing the Date Format


Select SaleDateConverted, CONVERT(Date, SaleDate)
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;


Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)




-- Populate Property Address Data



Select *
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing
-- WHERE PropertyAddress is null
ORDER BY ParcelID


Select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing a
JOIN NashvilleHousingPortfolioProject.dbo.NashvilleHousing b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing a
JOIN NashvilleHousingPortfolioProject.dbo.NashvilleHousing b
	ON a.parcelID = b.parcelID
	AND a.[UniqueID ] != b.[UniqueID ]
WHERE a.PropertyAddress is null





-- Breaking Down Address into Individual Columns


SELECT PropertyAddress
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))




SELECT OwnerAddress
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



SELECT *
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing




-- Changing Y to Yes and N to No in SoldAsVacant Field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2




SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing



Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END





-- Remove Duplicates


WITH RowNumCTE AS (
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		PropertyAddress, 
		SalePrice, 
		SaleDate, 
		LegalReference
		ORDER BY 
			UniqueID
			) row_num
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing
-- ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
-- ORDER BY PropertyAddress



-- Deleting Unused Columns



SELECT *
FROM NashvilleHousingPortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousingPortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
















