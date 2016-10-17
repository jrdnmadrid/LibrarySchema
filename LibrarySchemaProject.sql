USE LibrarySchema
GO

/*OVERVIEW: The goal of this execise is to create a Library Schema to answer the below questions, which are detailed later in the comments

1. How many copies of the book titled The Lost Tribe are owned by the library branch whose name
is "Sharpstown"? 
2. How many copies of the book titled The Lost Tribe are owned by each library branch?
3. Retrieve the names of all borrowers who do not have any books checked out.
4.   For   each   book   that   is   loaned   out   from   the   "Sharpstown"   branch   and   whose   DueDate   is   today,
retrieve the book title, the borrower's name, and the borrower's address.
5. For each library branch, retrieve the branch name and the total number of books loaned out from
that branch.
6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more
than five books checked out.
7. For each book authored (or co-authored) by "Stephen King", retrieve the title and the number of
copies owned by the library branch whose name is "Central"
Now, create a stored procedure that will execute one or more of those queries, based on user
choice.
*/

--STEP 1: I created the seven tables needed to start the library schema. These include Book, Book_Authors, Publisher, Book_Copies, Book_Loans, Library_Branch, Borrower. 
--I also made sure to link key relationships as shown in the diagram in the readme file. 

CREATE TABLE Book (BookID INT PRIMARY KEY, Title VARCHAR(30) NOT NULL, PublisherName VARCHAR(30))
GO

CREATE TABLE Book_Authors (BookID INT, Author_Name varchar(30))
GO

CREATE TABLE Publisher ([Name] varchar(30) PRIMARY KEY, [Address] varchar(60), Phone INT)
GO

CREATE TABLE Book_Copies (BookID INT, BranchID INT, No_Of_Copies INT) 
GO

CREATE TABLE Book_Loans (BookID INT, BranchID INT, CardNo INT, DateOut DATE, DueDate DATE)
GO

CREATE TABLE Library_Branch (BranchID INT PRIMARY KEY, BranchName VARCHAR(30), [Address] VARCHAR (60))
GO

CREATE TABLE Borrower (CardNo INT PRIMARY KEY, [Name] VARCHAR(30), [Address] VARCHAR (60), Phone VARCHAR (13) 
GO

/*STEP 2: Now, I will populate all the tables with dummy data in order to accomplish the original goals laid at the top.
To answer the questions, there are a few parameters that need to be set: 

1. There is a book called 'The Lost Tribe'.
2. There is a library branch called 'Sharpstown' and one called 'Central'.
3. There are at least 20 books in the BOOK table.
4. There are at least 10 authors in the BOOK_AUTHORS table.
5. Each library branch has at least 10 book titles, and at least two copies of each of those titles.
6. There are at least 8 borrowers in the BORROWER table, and at least 2 of those borrowers have more
than 5 books loaned to them.
7. There are at least 4 branches in the LIBRARY_BRANCH table.
8. There are at least 50 loans in the BOOK_LOANS table.
9. There must be at least one book written by 'Stephen King'.
*/ 

--I will first handle parameters #1 (there is a book called 'Lost Tribe') and #3 (there are at least 20 books in the Book table) and populate my dummy data accordingly. I will need to keep in mind there needs to be 10 authors in book_authors table as expressed in #4. 
--I split each transaction in order to allow others to track each data point, normally I would aggregate the inserts all in one command in order to speed up processing time. 


SELECT * FROM Book;

BEGIN TRANSACTION

INSERT INTO Book VALUES (1, 'The Lost Tribe', '24 West 26th Street Press'); 
INSERT INTO Book VALUES (2, 'The Shining', 'Anchor');
INSERT INTO Book VALUES (3, '1Q84', 'Vintage');
INSERT INTO Book VALUES (4, 'The Wind-Up Bird Chronicle', 'Vintage') 
INSERT INTO Book VALUES (5, 'Crime And Punishment', 'HarperPerennial Classics')
INSERT INTO Book VALUES (6, 'Don Quixote', 'Penguin');
INSERT INTO Book VALUES (7, 'Foundation', 'Bantam Books'); 
INSERT INTO book VALUES (8, 'Animal Farm', 'Houghton Mifflin Harcourt');
INSERT INTO book VALUES (9, 'The Metamorphosis', 'Classix Press'); 
INSERT INTO book VALUES (10, 'The Scarlet Letter', 'Ticknor and Fields'); 
INSERT INTO book VALUES (11, 'The Souls of Black Folk', 'Dover Publications'); 
INSERT INTO Book VALUES (12, 'The Great Gatsby', 'Benediction Books');
INSERT INTO Book VALUES (13, 'Slaughterhouse-Five', 'Chelsea House Pub'); 
INSERT INTO Book VALUES (14, 'The Catcher in the Rye', 'Little, Brown and Company');
INSERT INTO Book VALUES (15, 'To Kill a Mockingbird', 'Grand Central Publishing'); 
INSERT INTO Book VALUES (16, 'Of Mice and Men', 'Penguin Books'); 
INSERT INTO Book VALUES (17, 'Flowers for Algernon', 'Mariner Books'); 
INSERT INTO Book VALUES (18, 'Rendezvous with Rama', 'RosettaBooks'); 
INSERT INTO Book VALUES (19, 'Childhood''s End', 'RosettaBooks'); 
INSERT INTO Book VALUES (20, 'Gateway', 'Del Rey'); 
INSERT INTO Book VALUES (21, 'The Pearl', 'Penguin Books');

 COMMIT TRANSACTION

 --Now I will handle parameters #4 (there are at least 10 authors in the BOOK_AUTHORS table) and #9 (there must be at least one book written by 'Stephen King') and begin filling out the authors for each of the books I have created above. 
 --Again, separating them out so you can see each line of code clearly. If this was a larger database I would group them accordingly. 

 SELECT * FROM Book_Authors;


BEGIN TRANSACTION

INSERT INTO Book_Authors VALUES (1, 'Mark Lee');
INSERT INTO Book_Authors VALUES (2, 'Stephen King');
INSERT INTO Book_Authors VALUES (3, 'Haruki Murakami');
INSERT INTO Book_Authors VALUES (4, 'Haruki Murakami'); 
INSERT INTO Book_Authors VALUES (5, 'Fyodor Dostoyevsky'); 
INSERT INTO Book_Authors VALUES (6, 'Miguel de Cervantes'); 
INSERT INTO Book_Authors VALUES (7, 'Isaac Asimov');
INSERT INTO Book_Authors VALUES (8, 'George Orwell'); 
INSERT INTO Book_Authors VALUES (9, 'Franz Kafka'); 
INSERT INTO Book_Authors VALUES (10, 'Nathaniel Hawthorne'); 
INSERT INTO Book_Authors VALUES (11, 'W.E.B. Du Bois');
INSERT INTO Book_Authors VALUES (12, 'F. Scott Fitzgerald');
INSERT INTO Book_Authors VALUES (13, 'Kurt Vonnegut');
INSERT INTO Book_Authors VALUES (14, 'J.D. Salinger');
INSERT INTO Book_Authors VALUES (15, 'Harper Lee'); 
INSERT INTO Book_Authors VALUES (16, 'John Steinbeck');
INSERT INTO Book_Authors VALUES (17, 'Daniel Keyes'); 
INSERT INTO Book_Authors VALUES (18, 'Arthur C. Clarke'); 
INSERT INTO Book_Authors VALUES (19, 'Arthur C. Clarke'); 
INSERT INTO Book_Authors VALUES (20, 'Frederik Pohl'); 
INSERT INTO Book_Authors VALUES (21, 'John Steinbeck'); 

COMMIT TRANSACTION;

/* I have the below steps left after completing the above actions: 

2. There is a library branch called 'Sharpstown' and one called 'Central'.
5. Each library branch has at least 10 book titles, and at least two copies of each of those titles.
6. There are at least 8 borrowers in the BORROWER table, and at least 2 of those borrowers have more
than 5 books loaned to them.
7. There are at least 4 branches in the LIBRARY_BRANCH table.
8. There are at least 50 loans in the BOOK_LOANS table.
*/ 

--Now I will handle parameters #2 (there is a library branch called 'Sharpstown' and one called 'Central') and #7 (there are at least 4 branches in the LIBRARY_BRANCH table) for the Library_branch table

SELECT * FROM Library_Branch

BEGIN TRANSACTION

INSERT INTO Library_Branch VALUES (1, 'Sharpstown', '7504 Bissonnet Street, Houston, Texas 77074');
INSERT INTO Library_Branch VALUES (2, 'Central', '89 East 42nd Street, New York, New York 10017');
INSERT INTO Library_Branch VALUES (3, 'Gladstone', '135 East Dartmouth Street, Gladstone, Oregon 97027');
INSERT INTO Library_Branch VALUES (4, 'Peabody', '7 East Mount Vernon Place, Baltimore, Maryland 21202');

COMMIT TRANSACTION; 

--Now I will handle parameter #5 (each library branch has at least 10 book titles, and at least two copies of each of those titles).
--These titles do not need to be unique and titles can be duplicated across branches. 

SELECT *  FROM Book_Copies

BEGIN TRANSACTION 

--Branch 1
INSERT INTO Book_Copies VALUES (1, 1, 2);
INSERT INTO Book_Copies VALUES (2, 1, 2);
INSERT INTO Book_Copies VALUES (3, 1, 2);
INSERT INTO Book_Copies VALUES (4, 1, 2);
INSERT INTO Book_Copies VALUES (5, 1, 2);
INSERT INTO Book_Copies VALUES (6, 1, 2);
INSERT INTO Book_Copies VALUES (7, 1, 2);
INSERT INTO Book_Copies VALUES (8, 1, 2);
INSERT INTO Book_Copies VALUES (9, 1, 2);
INSERT INTO Book_Copies VALUES (10, 1, 2);

--Branch 2
INSERT INTO Book_Copies VALUES (11, 2, 2);
INSERT INTO Book_Copies VALUES (12, 2, 2);
INSERT INTO Book_Copies VALUES (13, 2, 2);
INSERT INTO Book_Copies VALUES (14, 2, 2);
INSERT INTO Book_Copies VALUES (15, 2, 2);
INSERT INTO Book_Copies VALUES (16, 2, 2);
INSERT INTO Book_Copies VALUES (17, 2, 2);
INSERT INTO Book_Copies VALUES (18, 2, 2);
INSERT INTO Book_Copies VALUES (19, 2, 2);
INSERT INTO Book_Copies VALUES (20, 2, 2);


--Branch 3
INSERT INTO Book_Copies VALUES (21, 3, 2);
INSERT INTO Book_Copies VALUES (1, 3, 2);
INSERT INTO Book_Copies VALUES (2, 3, 2);
INSERT INTO Book_Copies VALUES (3, 3, 2);
INSERT INTO Book_Copies VALUES (4, 3, 2);
INSERT INTO Book_Copies VALUES (5, 3, 2);
INSERT INTO Book_Copies VALUES (6, 3, 2);
INSERT INTO Book_Copies VALUES (7, 3, 2);
INSERT INTO Book_Copies VALUES (8, 3, 2);
INSERT INTO Book_Copies VALUES (9, 3, 2);


--Branch 4
INSERT INTO Book_Copies VALUES (10, 4, 2);
INSERT INTO Book_Copies VALUES (11, 4, 2);
INSERT INTO Book_Copies VALUES (12, 4, 2);
INSERT INTO Book_Copies VALUES (13, 4, 2);
INSERT INTO Book_Copies VALUES (14, 4, 2);
INSERT INTO Book_Copies VALUES (15, 4, 2);
INSERT INTO Book_Copies VALUES (16, 4, 2);
INSERT INTO Book_Copies VALUES (17, 4, 2);
INSERT INTO Book_Copies VALUES (18, 4, 2);
INSERT INTO Book_Copies VALUES (19, 4, 2);

COMMIT TRANSACTION

--Now I will work on parameter #6 and parameter #8 to finalize the project, starting with first part of parameter 6. 
--Parameter 6 (There are at least 8 borrowers in the BORROWER table, and at least 2 of those borrowers have more than 5 books loaned to them.)
--Parameter 8 (There are at least 50 loans in the BOOK_LOANS table.)


SELECT * FROM Borrower;

--First part of the parameter #6 (there are at least 8 borrowers in the BORROWER table)

BEGIN TRANSACTION

INSERT INTO Borrower VALUES (1, 'John Jacobs', '17247 South Hanneman Court, Gladstone, Oregon 97037', '503-545-2563');
INSERT INTO Borrower VALUES (2, 'Jacob Smith', '1427 North Jackson Street, Baltimore, Maryland 21117', '219-206-3322'); 
INSERT INTO Borrower VALUES (3, 'Jebediah Strong', '3123, West Marksman Road, Nashville, Tennessee 29458', '325-222-4456'); 
INSERT INTO Borrower VALUES (4, 'Mary Magdelane', '5252 West Martin Way, Seattle, Washington 99258', '553-625-4252'); 
INSERT INTO Borrower VALUES (5, 'Robery Kennedy', '2254 South Cooper Street, Los Angeles, California 97210', '525-555-2254'); 
INSERT INTO Borrower VALUES (6, 'Lucy Liu', '5252 Hansen Street, San Diego, California 95625', '502-503-5588'); 
INSERT INTO Borrower VALUES (7, 'Jack Kennedy', '1417 Dynasty Drive, Chicago, Illinois 52555', '333-503-6679'); 
INSERT INTO Borrower VALUES (8, 'Donald Trump', 'One Trump Tower, New York, New York 22665', '234-657-8794'); 
INSERT INTO Borrower VALUES (9, 'Barack Obama', '1499 Country Way, Paradise, Michigan 33053', '562-678-2244'); 

COMMIT TRANSACTION

--I will now start parameter 8, as I will make sure to satisfy the second part of parameter #6 at the same time.  
--Parameter 8 (There are at least 50 loans in the BOOK_LOANS table.)
--Second part of parameter 6 (at least 2 of those borrowers have more than 5 books loaned to them.). You will notice both John Jacobs and Jacob Smith (cardno. 1 and 2) have more than 5 books loaned to them

SELECT * FROM Book_Loans

INSERT INTO Book_Loans VALUES (1, 1, 1, 'January 17, 2016', 'January 18, 2016'); 
INSERT INTO Book_Loans VALUES (2, 1, 1, 'January 22, 2016', 'October 30, 2016'); 
INSERT INTO Book_Loans VALUES (3, 1, 1, 'January 25, 2016', 'October 17, 2016'); 
INSERT INTO Book_Loans VALUES (4, 1, 1, 'March 22, 2016', 'October 17, 2016'); 
INSERT INTO Book_Loans VALUES (5, 1, 1, 'April 2, 2016', 'October 22, 2016');
INSERT INTO Book_Loans VALUES (6, 1, 1, 'August 22, 2016', 'November 1, 2016');  
INSERT INTO Book_Loans VALUES (7, 1, 1, 'September 1, 2016', 'December 10, 2016'); 
INSERT INTO Book_Loans VALUES (8, 1, 1, 'October 10, 2016', 'November 5, 2016'); 
INSERT INTO Book_Loans VALUES (9, 1, 1, 'October 9, 2016', 'October 17, 2016'); 
INSERT INTO Book_Loans VALUES (10, 1, 1, 'October 10, 2016', 'October 19, 2016'); 
INSERT INTO Book_Loans VALUES (11, 2, 2, 'September 22, 2016', 'October 30, 2016'); 
INSERT INTO Book_Loans VALUES (12, 2, 2, 'September 25, 2016', 'October 20, 2016'); 
INSERT INTO Book_Loans VALUES (13, 2, 2, 'October 15, 2016', 'November 22, 2016'); 
INSERT INTO Book_Loans VALUES (14, 2, 2, 'October 14, 2016', 'October 25, 2016'); 
INSERT INTO Book_Loans VALUES (15, 2, 2, 'October 12, 2016', 'November 1, 2016') 
INSERT INTO Book_Loans VALUES (16, 2, 2, 'October 15, 2016', 'November 22, 2016'); 
INSERT INTO Book_Loans VALUES (17, 2, 3, 'October 10, 2016', 'December 15, 2016'); 
INSERT INTO Book_Loans VALUES (18, 2, 3, 'September 20, 2016', 'November 10, 2016'); 
INSERT INTO Book_Loans VALUES (19, 2, 3, 'September 10, 2016', 'November 20, 2016'); 
INSERT INTO Book_Loans VALUES (20, 2, 3, 'September 15, 2016', 'October 25, 2016');
INSERT INTO Book_Loans VALUES (21, 3, 4, 'September 22, 2016', 'October 29, 2016'); 
INSERT INTO Book_Loans VALUES (1, 3, 4, 'September 15, 2016', 'October 17, 2016'); 
INSERT INTO Book_Loans VALUES (2, 3, 4, 'September 22, 2016', 'October 19, 2016'); 
INSERT INTO Book_Loans VALUES (3, 3, 4, 'September 19, 2016', 'October 22, 2016'); 
INSERT INTO Book_Loans VALUES (4, 3, 5, 'September 25, 2016', 'November 10, 2016'); 
INSERT INTO Book_Loans VALUES (5, 3, 5, 'September 25, 2016', 'October 22, 2016'); 
INSERT INTO Book_Loans VALUES (6, 3, 5, 'September 22, 2016', 'October 20, 2016');
INSERT INTO Book_Loans VALUES (7, 3, 5, 'September 11, 2016', 'October 18, 2016');
INSERT INTO Book_Loans VALUES (8, 3, 5, 'September 13, 2016', 'November 15, 2016');
INSERT INTO Book_Loans VALUES (9, 3, 5, 'September 12, 2016', 'October 18, 2016'); 
INSERT INTO Book_Loans VALUES (10, 4, 6, 'September 10, 2016', 'October 18, 2016');
INSERT INTO Book_Loans VALUES (11, 4, 6, 'September 22, 2016', 'October 19, 2016'); 
INSERT INTO Book_Loans VALUES (12, 4, 6, 'September 21, 2016', 'November 5, 2016');
INSERT INTO Book_Loans VALUES (13, 4, 6, 'September 19, 2016', 'October 20, 2016');
INSERT INTO Book_Loans VALUES (14, 4, 6, 'September 18, 2016', 'October 21, 2016');
INSERT INTO Book_Loans VALUES (15, 4, 6, 'August 30, 2016', 'November 2, 2016'); 
INSERT INTO Book_Loans VALUES (16, 4, 6, 'September 10, 2016', 'October 17, 2016');
INSERT INTO Book_Loans VALUES (17, 4, 6, 'September 10, 2016', 'September 15, 2016');
INSERT INTO Book_Loans VALUES (18, 4, 6, 'September 19, 2016', 'November 10, 2016'); 
INSERT INTO Book_Loans VALUES (19, 4, 6, 'September 20, 2016', 'November 2, 2016'); 
INSERT INTO Book_Loans VALUES (1, 1, 7, 'September 22, 2016', 'October 16, 2016');
INSERT INTO Book_Loans VALUES (2, 1, 7, 'September 21, 2016', 'October 18, 2016'); 
INSERT INTO Book_Loans VALUES (3, 1, 7, 'September 19, 2016', 'OCtober 19, 2016');
INSERT INTO Book_Loans VALUES (4, 1, 7, 'September 10, 2016', 'September 11, 2016');
INSERT INTO Book_Loans VALUES (5, 1, 7, 'September 13, 2016', 'October 10, 2016'); 
INSERT INTO Book_Loans VALUES (6, 1, 7, 'September 14, 2016', 'October 15, 2016'); 
INSERT INTO Book_Loans VALUES (7, 1, 7, 'September 16, 2016', 'November 10, 2016');
INSERT INTO Book_Loans VALUES (8, 1, 7, 'September 13, 2016', 'October 20, 2016'); 
INSERT INTO Book_Loans VALUES (9, 1, 7, 'September 9, 2016', 'October 17, 2016');
INSERT INTO Book_Loans VALUES (10, 1, 7, 'September 10, 2016', 'October 20, 2016'); 
INSERT INTO Book_Loans VALUES (11, 2, 7, 'September 11, 2016', 'November 10, 2016');
INSERT INTO Book_Loans VALUES (12, 2, 7, 'October 10, 2016', 'November 15, 2016'); 