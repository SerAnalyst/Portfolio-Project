/*
Cleaning Data in SQL Queries
*/

Select*
From NashvilleHousing

--Staandardize Date Format--

Select SaleDate1 , CONVERT(date,SaleDate)
From NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate =  CONVERT(date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDate1 date ; 

UPDATE NashvilleHousing
SET SaleDate1 =  CONVERT(date,SaleDate)

-- Populate Property Address data

Select*
From NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

Select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , isnull( a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET a.PropertyAddress = isnull( a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing
--where PropertyAddress is null 
--order by ParcelID

Select 
substring (PropertyAddress,1, CHARINDEX(',' ,PropertyAddress)-1)  as Address ,
substring (PropertyAddress, CHARINDEX(',' ,PropertyAddress) + 1, len (PropertyAddress))  as Address

from NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertysplitAddress  Nvarchar(250) ; 

UPDATE NashvilleHousing
SET PropertysplitAddress =  substring (PropertyAddress,1, CHARINDEX(',' ,PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
Add Propertysplitcity  Nvarchar(250) ; 

UPDATE NashvilleHousing
SET Propertysplitcity =  substring (PropertyAddress, CHARINDEX(',' ,PropertyAddress) + 1, len (PropertyAddress))

Select*
From NashvilleHousing

Select OwnerAddress
From NashvilleHousing

SELECT
PARSENAME (REPLACE(OwnerAddress, ',','.'),3)
,PARSENAME (REPLACE(OwnerAddress, ',','.'),2)
,PARSENAME (REPLACE(OwnerAddress, ',','.'),1)


FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnersplitAddress  Nvarchar(250) ; 

UPDATE NashvilleHousing
SET OwnersplitAddress =  PARSENAME (REPLACE(OwnerAddress, ',','.'),3)

ALTER TABLE NashvilleHousing
Add Ownersplitcity Nvarchar(250) ; 

UPDATE NashvilleHousing
SET Ownersplitcity =  PARSENAME (REPLACE(OwnerAddress, ',','.'),2)

ALTER TABLE NashvilleHousing
Add Ownersplitstate  Nvarchar(250) ; 

UPDATE NashvilleHousing
SET Ownersplitstate =  PARSENAME (REPLACE(OwnerAddress, ',','.'),1)


Select*
From NashvilleHousing


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant) , COUNT(SoldAsVacant)
From NashvilleHousing
group  by (SoldAsVacant)
order by 2


SELECT SoldAsVacant
,CASE 
	When SoldAsVacant = 'Y' then  'YES'
	When SoldAsVacant = 'N' then  'No'
	ELSE SoldAsVacant
	END

From NashvilleHousing



UPDATE NashvilleHousing
SET SoldAsVacant = CASE  
	When SoldAsVacant = 'Y' then  'YES'
	When SoldAsVacant = 'N' then  'No'
	ELSE SoldAsVacant
	END

	-- Remove Duplicates


with RoudNumCTE as (
Select* ,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)  row_num

From NashvilleHousing
--order by ParcelID
)
--delete 
Select*
from RoudNumCTE
where row_num > 1
--order by PropertyAddress


-- Delete Unused Columns

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress ,TaxDistrict , PropertyAddress

Select*
From NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate