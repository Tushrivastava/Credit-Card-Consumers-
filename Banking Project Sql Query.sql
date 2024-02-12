--- 1.Do males or females use more banking in different countries? 

select Geography,Gender,count(Gender) as total_count 
from customer
group by  Geography,Gender
order by Geography


----2.What is average credit score by countries? 

select  c.geography, round( avg(c2.CreditScore),2)as avg_credit_score
from customer c join credit_score c2 on c.customerid = c2.customerid
group by c.geography;


--- 3.What percent of customers with hight credit score has low estimated salary?

select Count(b2.customerid) * 100/count(c2.customerid)as Pct_Customer
from customer c2 
left join (select * from dbo.[balance salary] where EstimatedSalary<50000 and CreditScore>600) as b2
on b2.customerid=c2.customerid

----4. Max creditscore by countries
select * 
from (select  c2.*, c.geography, row_number() over(partition by geography order by c2.creditscore DESC) as rnmb
from customer c join credit_score c2 on c.customerid = c2.customerid ) as a
where a.rnmb = 1;

------5.Average age of active memebers by countries
select c.geography, round(avg(c.age),0)as Act_Members
from customer c where customerid in
(select customerid from credit  where isactivemember = 1)
group by c.geography;


----6.Number of coustomers with  balance >75000 by gender and by countries
select gender, geography, count(customerid)as Count_Customers
from customer c where customerid in (select customerid from dbo.[balance salary] b2 where balance > 75000)
group by gender, geography
order by geography,gender;


-----7.Average credit score and avg estimated salary with high balance by gender and country
select gender, geography, round( avg(creditscore),1) as acs, round(avg(estimatedsalary),1) as avg_salary
from customer c join dbo.[balance salary] b2 on c.customerid = b2.customerid 
where balance > 75000
group by gender, geography
order by geography,gender;


----- 8. Find people who has card, is exited and surname starts with A.View all this)
create view ab as
select surname
from customer c3 join (select * from credit c2 where c2.hascrcard =1 and c2.exited =1 ) as jj
on c3.customerid =jj.customerid
where surname like 'A%';

select * from ab;