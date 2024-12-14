use henrybooksdb;

-- List the name of each publisher that's not located in New York.

SELECT PublisherName
FROM Publisher
WHERE NOT City = 'New York';

-- List the title of each book published by Penguin USA.

SELECT Title
FROM Book B, Publisher P
WHERE B.PublisherCode = P.PublisherCode
AND B.PublisherCode = 'PE';

-- List the title of each book that has the type MYS.

SELECT Title 
FROM Book
WHERE Type = 'MYS';

-- List the title of each book that has the type SFI and that is in paperback.

SELECT Title 
FROM Book
WHERE Type = 'SFI' AND Paperback = 'TRUE';

--  List the title of each book that has the type PSY or whose Publisher code is JP.

SELECT Title 
FROM Book
WHERE Type = 'PSY' 
OR PublisherCode = 'JP';

--  List the title of each book that has the type CMP, HIS, or SCI.

SELECT Title 
FROM Book
WHERE Type IN ('CMP', 'HIS', 'SCI');

-- How many books have a publisher code of ST or VB.

SELECT COUNT(*)
FROM Book
WHERE PublisherCode IN ('ST', 'VB');

-- List the title of each book written by Dick Francis.

SELECT B.Title
FROM Book B
JOIN Wrote W 
ON B.BookCode = W.BookCode
JOIN Author A
ON W.AuthorNum = A.AuthorNum
WHERE A.AuthorFirstname = 'Dick'
AND A.AuthorLastname = 'Francis';

-- List the title of each book that has the type FIC and that was written by John Steinbeck.

SELECT B.Title
FROM Book B
JOIN Wrote W 
ON B.BookCode = W.BookCode
JOIN Author A
ON W.AuthorNum = A.AuthorNum
WHERE B.Type = 'FIC'
AND A.AuthorFirstname = 'John'
AND A.AuthorLastname = 'Steinbeck';

-- For each book with coauthors, list the title, publisher code, type, and author names (in the order listed on the cover).

SELECT B.Title, B.PublisherCode, B.Type, A.AuthorFirstname, A.AuthorLastName
FROM Book B
JOIN Wrote W
ON B.BookCode = W.BookCode
JOIN Author A
ON W.AuthorNum = A.AuthorNum
WHERE B.BookCode IN (SELECT BookCode FROM Wrote GROUP BY BookCode HAVING COUNT(*) > 1)
ORDER BY B.Title, W.Sequence;


-- How many book copies have a price that is greater than $20 but less than $25.

SELECT COUNT(*)
FROM Copy
WHERE Price > 20 AND Price < 25;

-- list the branch number, copy number, quality and price for each copy of The Stranger.

SELECT C.BranchNum, C.CopyNum, C.Quality, C.Price
FROM Copy C
JOIN Book B
ON C.BookCode = B.BookCode
WHERE B.Title = 'The Stranger';

-- list the branch name, copy number, quality and price for each copy of Electric Light.

SELECT R.BranchName, C.CopyNum, C.Quality, C.Price
FROM Copy C
JOIN Book B
ON C.BookCode = B.BookCode
JOIN Branch R
ON C.BranchNum = R.BranchNum
WHERE B.Title = 'The Stranger';

-- For each book copy with a price greater than $25, list the book's title, quality and price.

SELECT B.Title, C.Quality, C.Price
FROM Copy C
JOIN Book B
ON C.BookCode = B.BookCode
WHERE C.Price > 25;

/* For each book copy available at the Henry on the Hill branch whose quality is excellent, list the book's title
and author names (in the order listed on the cover). */

SELECT B.Title, A.AuthorFirstname, A.AuthorLastname
FROM Author A
JOIN Wrote W ON A.AuthorNum = W.AuthorNum
JOIN Book B ON W.BookCode = B.BookCode
JOIN Copy C ON B.BookCode = C.BookCode
JOIN Branch R ON C.BranchNum = R.BranchNum
WHERE R.BranchName = 'Henry on the Hill' AND C.quality = 'Excellent'
GROUP BY B.BookCode, B.Title, A.AuthorFirstname, A.AuthorLastname;

/* Create a new table called FictionCopies using the data in the BookCode, Title, BranchNum, CopyNum,
Quality, and Price columns for those books that have the type FIC. */

CREATE TABLE FictionCopies AS
SELECT C.BookCode, B.Title, C.BranchNum, C.CopyNum, C.Quality, C.Price
FROM Book B, Copy C
WHERE B.BookCode = C.BookCode
AND B.Type = 'FIC';

SELECT *
FROM FictionCopies;

/* Ray Henry is considering increasing the price of all copies of fiction books whose quality is excellent by 10%.
To determine the new prices, list the BookCode, Title and increased price of every book in the FictionCopies table
(Your computed column should determine 110% of the current price, which is 100% plus a 10% increase). */

SELECT BookCode, Title, 1.1*Price AS IncreasedPrice
FROM FictionCopies
WHERE Quality = 'Excellent';

-- Use an update query to change the price of each book in the FictionCopies table with a price of $14.00 to $14.50.

UPDATE FictionCopies
SET Price = 14.5
WHERE Price = 14;

-- Use a delete query to delete all books in the FictionCopies table whose quality is Poor.

DELETE FROM FictionCopies
WHERE Quality = 'Poor';

/* Create a view named PenguinBooks. It consists of the book code, book title, type, price for every book published by
Penguin USA. Display the data in the view. */

CREATE VIEW PenguinBooks AS
SELECT C.BookCode, B.Title, B.Type, C.Price
FROM Copy C
JOIN Book B
ON C.BookCode = B.BookCode
JOIN Publisher P
ON B.PublisherCode = P.PublisherCode
WHERE P.PublisherName = 'Penguin USA';

SELECT*
FROM PenguinBooks;

/* Create a view named Paperback. It consists of the book code, book title, publisher name, branch number, copy number
 and Price for every book that is available in paperback. Display the data in the view. */
 
 CREATE VIEW Paperback AS
 SELECT C.BookCode, B.Title, P.PublisherName, C.BranchNum, C.CopyNum, C.Price
 FROM Copy C
 JOIN Book B
 ON C.BookCode = B.BookCode
 JOIN Publisher P
 ON B.PublisherCode = P.PublisherCode
 WHERE PaperBack = 'TRUE';
 
 SELECT*
 FROM Paperback;
 
 /* Create a view named BookAuthor. It consists of the book code, book title, type, author number, first name,
 last name and sequence number for each book. Display the data in the view. */
 
 CREATE VIEW BookAuthor AS
 SELECT W.BookCode, B.Title, B.Type, W.AuthorNum, A.AuthorFirstname, A.AuthorLastname, W.Sequence
 FROM Wrote W
 JOIN Book B
 ON W.BookCode = B.BookCode
 JOIN Author A
 ON W.AuthorNum = A.AuthorNum;
 
 SELECT*
 FROM BookAuthor;
 
 -- Create an index named BookIndex1 on the PublisherName field in the Publisher table.
 
 CREATE INDEX BookIndex1 ON Publisher(PublisherName(500));
 
 -- Create an index named BookIndex2 on the Type field in the Book table.
 
 CREATE INDEX BookIndex2 ON Book(Type(200));
 
 /* Create an index named BookIndex3 on the BookCode and Type fields in the Book table
  and list the book codes in descending order. */
  
  CREATE INDEX BookIndex3 ON Book(BookCode, Type(200));
  
  SELECT BookCode
  FROM Book
  ORDER BY BookCode DESC;
  
  -- Drop the BookIndex3 index.
  
  DROP INDEX BookIndex3 ON Book;
  
  -- specify the integrity constraint that the price of any book must be less than 90$.
  
  ALTER TABLE Copy
  ADD CONSTRAINT CheckPrice CHECK (Price < 90);
  
  -- To ensure that Publishercode is a foreign key in the Book table and maintains referential integrity.
  
  SELECT* 
  FROM Book 
  WHERE PublisherCode NOT IN (SELECT PublisherCode FROM Publisher);
  
  -- To ensure that BranchNum is a foreign key in the Copy table and maintains referential integrity.
  
  SELECT* 
  FROM Copy 
  WHERE BranchNum NOT IN (SELECT BranchNum FROM Branch);
  
  -- To ensure that AuthorNum is a foreign key in the Wrote table and maintains referential integrity.
 
 SELECT* 
 FROM Wrote 
 WHERE AuthorNum NOT IN (SELECT AuthorNum FROM Author);
 
 -- Add to the Book table a new character field named Classic that is one character in length.
 
 ALTER TABLE Book
 ADD COLUMN Classic CHAR(1);
 
 -- Change the Classic field in the Book table to Y fot the book titled The Grapes of Wrath.
 
 UPDATE Book
 SET Classic = 'Y'
 WHERE Title = 'The Grapes of Wrath';
 
 -- Change the Length of the Title field in the Book table to 60.
 
 ALTER TABLE Book
 CHANGE Title Title VARCHAR(60);
 
 

  
  
  
 
  







