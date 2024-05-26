create database library_database;


use library_database;

-- Parent Table

create table tbl_publisher(publisher_publishername varchar(255) primary key,
								publisher_publisheraddress varchar(255),
                                publisher_publisherphone varchar(255));
-- Parent Table

create table tbl_borrower(borrower_borrowercardno  tinyint  primary key auto_increment,
						borrower_borrowername varchar(255),
                        borrower_borroweraddress varchar(255),
                        borrower_borrowerphone varchar(255));
			
-- parent table
            
create table tbl_library_branch(library_branch_branchid tinyint primary key auto_increment,
								library_branch_branchname varchar(255),
                                library_branch_branchaddress varchar(255));
                                
                                
-- child table

create table tbl_book(book_bookid tinyint primary key auto_increment,
						book_tittle varchar(255),
                        book_publishername varchar(255),
                        foreign key(book_publishername) references tbl_publisher(publisher_publishername));
                        
-- child table

create table tbl_book_authors(book_authors_authorid tinyint primary key auto_increment,
								book_authors_bookid tinyint ,
                                book_authors_authorname varchar(255),
                                foreign key(book_authors_bookid) references tbl_book(book_bookid));
                                
-- child table 

create table tbl_book_copies(book_copies_copiesid tinyint primary key auto_increment,
								book_copies_bookid tinyint ,
                                foreign key(book_copies_bookid) references tbl_book(book_bookid),
                                book_copies_branchid tinyint ,
                                foreign key(book_copies_branchid) references tbl_library_branch(library_branch_branchid),
                                book_copies_no_of_copies tinyint );
            
   -- child table         
            
create table tbl_book_loans(book_loans_loansid tinyint primary key auto_increment,
							book_loans_bookid tinyint,
                            foreign key(book_loans_bookid) references tbl_book(book_bookid),
                            book_loans_branchid tinyint,
                            foreign key(book_loans_branchid) references tbl_library_branch(library_branch_branchid),
                            book_loans_cardno tinyint ,
                            foreign key(book_loans_cardno) references tbl_borrower(borrower_borrowercardno),
                            book_loans_dateout varchar(255),
                            book_loans_duedate varchar(255));
                            
	drop table tbl_book_loans;
                            
show tables;


select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_book_copies;
select * from tbl_book_loans;
select * from tbl_borrower;
select * from tbl_library_branch;
select * from tbl_publisher;


-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?


SELECT 
    tbc.book_copies_no_of_copies,tb.book_tittle
FROM
    tbl_book tb
        JOIN
    tbl_book_copies tbc ON tb.book_bookid = tbc.book_copies_bookid
        JOIN
    tbl_library_branch tlb ON tbc.book_copies_branchid = tlb.library_branch_branchid
WHERE
    tb.book_tittle = 'The Lost Tribe'
        AND tlb.library_branch_branchname = 'Sharpstown'
        ;
        
        

-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
 tbc.book_copies_no_of_copies
FROM
    tbl_book tb
        JOIN
    tbl_book_copies tbc ON tb.book_bookid = tbc.book_copies_bookid
        JOIN
    tbl_library_branch tlb ON tbc.book_copies_branchid = tlb.library_branch_branchid
WHERE
    tb.book_tittle = 'The Lost Tribe';
    
    
    
    
    -- 3. Retrieve the names of all borrowers who do not have any books checked out.
    
    SELECT 
    tb.borrower_borrowername
FROM
    tbl_borrower tb
        LEFT JOIN
    tbl_book_loans tbl ON tb.borrower_borrowercardno = tbl.book_loans_cardno
        LEFT JOIN
    tbl_book ON tbl.book_loans_bookid = tbl_book.book_bookid
WHERE
    tbl_book.book_tittle IS NULL;
    
     
    
    /* 4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, 
    retrieve the book title, the borrower's name, and the borrower's address.*/
    
    
SELECT 
    tbl_book.book_tittle,
    tb.borrower_borroweraddress,
    tb.borrower_borrowername
FROM
    tbl_Book_loans tbl
        LEFT JOIN
    tbl_library_branch tlb ON tbl.book_loans_branchid = tlb.library_branch_branchid
        LEFT JOIN
    tbl_borrower tb ON tbl.book_loans_cardno = tb.borrower_borrowercardno
        LEFT JOIN
    tbl_book ON tbl.book_loans_bookid = tbl_book.book_bookid
WHERE
    tlb.library_branch_branchname = 'Sharpstown'
        AND tbl.book_loans_duedate = '2/3/18';



-- 5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.


SELECT 
    tlb.library_branch_branchname, COUNT(tb.book_tittle) AS freq
FROM
    tbl_library_branch tlb
        LEFT JOIN
    tbl_book_loans tbl ON tlb.library_branch_branchid = tbl.book_loans_branchid
        LEFT JOIN
    tbl_book AS tb ON tbl.book_loans_bookid = tb.book_bookid
GROUP BY tlb.library_branch_branchname
ORDER BY freq;

-- 6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
 
 select * from tbl_borrower;
 select * from tbl_book_loans;
 select * from tbl_book;
 
 
SELECT 
    tb.borrower_borrowername,
    tb.borrower_borroweraddress,
    COUNT(tb1.book_tittle) AS freq
FROM
    tbl_borrower tb
        LEFT JOIN
    tbl_book_loans tbl ON tb.borrower_borrowercardno = tbl.book_loans_cardno
        LEFT JOIN
    tbl_book AS tb1 ON tbl.book_loans_bookid = tb1.book_bookid
GROUP BY tb.borrower_borrowername , tb.borrower_borroweraddress
having freq > 5;


-- 7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".

SELECT 
    tb.book_tittle,
    tbc.book_copies_no_of_copies,
    tba.book_authors_authorname,
    tlb.library_branch_branchname
FROM
    tbl_book_authors tba
        LEFT JOIN
    tbl_book tb ON tba.book_authors_bookid = tb.book_bookid
        LEFT JOIN
    tbl_book_copies tbc ON tb.book_bookid = tbc.book_copies_bookid
        LEFT JOIN
    tbl_library_branch tlb ON tbc.book_copies_branchid = tlb.library_branch_branchid
WHERE
    tba.book_authors_authorname = 'Stephen King'
        AND tlb.library_branch_branchname = 'Central';




                                
