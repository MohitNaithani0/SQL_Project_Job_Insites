Create DataBase Practice_Interview
-    Create Table Employee(
        EmpID int NOT NULL,
        EmpName Varchar,
        Gender Char,
        Salary int,
        City Char(20) )
		
-	INSERT INTO Employee
    VALUES (1, 'Arjun', 'M', 75000, 'Pune'),
   (2, 'Ekadanta', 'M', 125000, 'Bangalore'),
   (3, 'Lalita', 'F', 150000 , 'Mathura'),
   (4, 'Madhav', 'M', 250000 , 'Delhi'),
   (5, 'Visakha', 'F', 120000 , 'Mathura')
   
   
-   CREATE TABLE EmployeeDetail (
    EmpID int NOT NULL,
    Project Varchar,
    EmpPosition Char(20),
    DOJ date )
	
-   INSERT INTO EmployeeDetail
    VALUES 
    (1, 'P1', 'Executive', '2019-01-26'),
    (2, 'P2', 'Executive', '2020-05-04'),
    (3, 'P1', 'Lead', '2021-10-21'),
    (4, 'P3', 'Manager', '2019-11-29'),
    (5, 'P2', 'Manager', '2020-08-01');
	

-Q1(a): Find the list of employees whose salary ranges between 2L to 3L.


   Select * From Employee
   Where Salary Between 200000 And 300000;
   
   
-Q1(b): Write a query to retrieve the list of employees from the same city.


  Select E1.empid,E1.empname,E1.City
  From employee E1,Employee E2
  Where E1.City = E2.City And E1.empid != E2.empid
  
  
-Q1(c): Query to find the null values in the Employee table.
  
  
   Select * From Employee
   Where  EmpID is Null 
   

-Q2(a): Query to find the cumulative sum of employee’s salary.


    Select empname,salary, Sum(salary) Over(Order By empid) As Cumulative_Salary
	From Employee
	
	
-Q2(b): What’s the male and female employees ratio.
    
	
	Select Round(COUNT(*) Filter (Where gender = 'M')*100.00/Count(*), 2  )As Male_Ratio,
	Round(COUNT(*) Filter (Where gender = 'F')*100.00/Count(*),2 ) As Female_Ratio
	From Employee
	
	
-Q2(c): Write a query to fetch 50% records from the Employee table.


     SELECT * FROM employee
	 Where empid <= (Select Count(empid)/2 from Employee)
	 
 ---Or If Our Table have Not Define Us Any row Numbers
 
     Select * From (
	 Select *, ROW_NUMBER() OVER(ORDER By empid) As RowNumber
	 From Employee) As Emp
	 Where Emp.RowNumber <=(Select COUNT(empid)/2 From Employee )
	

Q3: Query to fetch the employee’s salary but replace the LAST 2 digits with ‘XX’
i.e 12345 will be 123XX
	
	
	Select empname,Salary,CONCAT(SUBSTRING(Salary::Text, 1 ,Length(Salary::Text) -2),'XX')As Hidden_Digit
	From employee
	

Q4: Write a query to fetch even and odd rows from Employee table.
	
    Select * From Employee
	Where MOD(Empid,2)= 1
	
 ---Or If Our Table have Not Define Us Any row Numbers
 
    Select * From(  
    Select *,
	Case When ROW_number() Over(Order By empid) %2 = 0 Then 'Even' Else 'Odd' End As Rows_type 
	From Employee
		)As Subquery
	Where Rows_Type = 'Even'
	Order By ROws_Type
	
	
Q5(a): Write a query to find all the Employee names whose name:
• Begin with ‘A’
• Contains ‘A’ alphabet at second place
• Contains ‘Y’ alphabet at second last place
• Ends with ‘L’ and contains 4 alphabets
• Begins with ‘V’ and ends with ‘A’


    Select * From Employee
	Where empname LIKE 'A%'
	
	Select * From Employee
	Where empname Like'_a%'
	
    Select * From Employee
	Where empname Like '%t_'
	
	Select * From Employee
	Where empname LIKE '_____a'
	
	Select * From Employee
	Where empname LIKE 'V%a'
  
  
Q5(b): Write a query to find the list of Employee names which is:
• starting with vowels (a, e, i, o, or u), without duplicates
• ending with vowels (a, e, i, o, or u), without duplicates
• starting & ending with vowels (a, e, i, o, or u), without duplicates


    Select Distinct(empname)
	From Employee
	Where LOWER(empname) Similar To '[aeiou]%'
	
	
	Select Distinct(empname)
	From Employee
	Where Lower(empname) Similar To '%[aeiou]'
	
	
	Select Distinct(empname)
	From Employee
	Where Lower(empname) Similar To '[aeiou]%[aeiou]'
	
	
Q6: Find Nth highest salary from employee table with and without using the
TOP/LIMIT keywords.
	
	
	Select Max(salary)
	From Employee
	Limit 1
	
	Select E1.Salary 
	From Employee E1
	Where 2-1 = (
	Select Count(distinct(E2.Salary))
	From Employee E2
	Where E2.Salary > E1.Salary)
	
	OR
	
	Select E1.Salary
	From Employee E1
	Where 2 = (
	Select Count(Distinct(E2.Salary))
	From Employee E2
	Where E1.Salary >= E2.Salary)

	
Q7(a): Write a query to find and remove duplicate records from a table.
	
	
	Select empid,empname,gender,salary,city,Count(*) As Duplicate_Count 
	From Employee
	Group BY Empid,Empname,gender,salary,city
	Having Count(*) > 1
 
    Delete From Employee
	Where Empid IN( 
	Select Empid From Employee
	Group BY empid
	Having Count(*) > 1)
	
	
Q7(b): Query to retrieve the list of employees working in same project.


    With CTE AS(
	  Select e.empid,e.empname,ed.project
	  From Employee AS e
	  Join EmployeeDetail AS ed
	  On e.empid = ed.empid)
	Select e1.empname,e2.empname,e1.project
	From CTE e1,CTE e2
	Where e1.project = e2.project And e1.empid != e2.empid And e1.empId < e2.empid
  
		
Q8: Show the employee with the highest salary for each project	


    Select ed.Project , Max(Salary) As ProjectSalary,SUM(e.Salary) TotalSal,Count(e.empid) As TotalEmp
	From Employee As e
	Inner Join EmployeeDetail As ed
	On e.Empid = ed.Empid
	Group By Project
	Order BY ProjectSalary DESC
	
	OR
	
	With CTE AS(
	Select project,empname,salary,
	Row_Number() Over (Partition BY project Order BY Salary DESC ) AS ROW_RANK
	From Employee e
	Inner JOIN EmployeeDetail As ed
	ON e.Empid = ed.Empid)
	Select project,empname,salary
	From CTE
	Where ROW_RANK = 1
	
	
Q9: Query to find the total count of employees joined each year
    
	
	SELECT EXTRACT('YEAR' from doj) AS JoinYear,count(*) AS EmpCount
	From employee AS e
	Inner JOIN EmployeeDetail As ed
	On e.EMPID = ed.EMPID
	Group BY JoinYear
	Order BY JoinYear ASC
    
	
Q10: Create 3 groups based on salary col, salary less than 1L is low, between 1 -
2L is medium and above 2L is High


    Select empname,salary,
	Case
	When salary < 100000 Then 'Low'
	When salary <= 200000 Then 'Medium'
	Else 'High' 
	End As SalaryStatus
	From Employee
	
	
BONUS: Query to pivot the data in the Employee table and retrieve the total
salary for each city.
The result should display the EmpID, EmpName, and separate columns for each

  	Select empid,empname ,
	  Sum(Case When City = 'Pune' then salary End) As "PUNE",
	  Sum(Case When City = 'Bangalore' then salary End) As "Bangalore",
      Sum(Case When City = 'Mathura' then salary End) As "Mathura",
	  Sum(Case When City = 'Delhi' then salary End) As "Delhi"
	From Employee
	Group By empid,empname
	
	
Select * from employee
	
	