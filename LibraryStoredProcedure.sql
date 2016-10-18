--I created the final stored procedure on a separate file set. 

CREATE PROCEDURE MostBooksChecked AS 
SELECT Borrower.[Name], Borrower.[Address], COUNT(Borrower.CardNo) AS 'Total Number of Book Loans'
FROM Book_Loans
INNER JOIN Library_Branch
ON Book_Loans.BranchID = Library_Branch.BranchID
INNER JOIN Book
ON Book_Loans.BookID = Book.BookID
INNER JOIN Borrower
ON Book_Loans.CardNo = Borrower.CardNo
WHERE Book_Loans.DueDate > GETDATE() AND Book_Loans.CardNo > 5
GROUP BY Borrower.[Name], Borrower.[Address]
GO

EXEC MostBooksChecked
