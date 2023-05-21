-- Looking at all the data

SELECT *
FROM BooksProject..Books


-- Checking to see which books are in/out of stock

SELECT Stock
FROM Books
WHERE Stock <> 'In stock'


-- Reading into how many different genres, average price, and deleting NULL values

SELECT DISTINCT Book_category
FROM Books


SELECT Book_category, COUNT(Book_category) AS TotalBooksByGenre
FROM Books
GROUP BY Book_category
ORDER BY TotalBooksByGenre DESC;


SELECT Book_category
FROM Books
WHERE Book_category = 'Add a comment' OR Book_category = 'Default'


DELETE FROM Books
WHERE Book_category = 'Add a comment' OR Book_category = 'Default'


SELECT TOP 10 Title, Book_category, MAX(Price) AS MostExpensiveBooks
FROM Books
GROUP BY Title, Book_category
ORDER BY 3 DESC;


SELECT Book_category, ROUND(AVG(Price), 2)
FROM BooksProject..Books
GROUP BY Book_category
ORDER BY AVG(Price) DESC


-- Changing the Star_ratings data type

UPDATE Books
SET Star_rating = 1
WHERE Star_rating = 'One'


UPDATE Books
SET Star_rating = 2
WHERE Star_rating = 'Two'


UPDATE Books
SET Star_rating = 3
WHERE Star_rating = 'Three'


UPDATE Books
SET Star_rating = 4
WHERE Star_rating = 'Four'



UPDATE Books
SET Star_rating = 5
WHERE Star_rating = 'Five'

ALTER TABLE Books
ALTER COLUMN Star_rating int;




-- Using Star_rating in order to suggest recommendations

SELECT Title, Book_category, Star_rating,
CASE
	WHEN Star_rating = 5 THEN 'Must Read!'
	WHEN Star_rating BETWEEN 3 AND 4 THEN 'Highly Recommend'
	WHEN Star_rating = 2 THEN 'Not Recommended'
	ELSE 'Avoid At All Costs'
END AS 'Recommendation'
FROM Books
WHERE Book_category = 'Romance'
ORDER BY 3 DESC;



SELECT Title, Book_category, Star_rating,
CASE
	WHEN Star_rating = 5 THEN 'Must Read!'
	WHEN Star_rating BETWEEN 3 AND 4 THEN 'Highly Recommend'
	WHEN Star_rating = 2 THEN 'Not Recommended'
	ELSE 'Avoid At All Costs'
END AS 'Recommendation'
FROM Books
WHERE Book_category = 'Mystery'
ORDER BY 3 DESC;


