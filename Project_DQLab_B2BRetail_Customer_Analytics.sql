/* DQLab Challenge
Question 1: Total Penjualan dan Revenue pada Q1 dan Q2*/

select sum(quantity) total_penjualan, sum(quantity*priceeach) revenue from orders_1 where status = "Shipped";
select sum(quantity) total_penjualan, sum(quantity*priceeach) revenue from orders_2 where status = "Shipped";

/* Question 2: Menghitung persentasi keseluruhan penjualan */

select quarter, sum(quantity) total_penjualan, sum(quantity*priceeach) revenue 
from 
(select 1 quarter, quantity, priceeach, status from orders_1
union
select 2 quarter, quantity, priceeach, status from orders_2) as tabel_a
where status = "Shipped"
group by quarter;

/* Question 3: Perhitungan growth penjualan dan revenue 
Apakah jumlah customer xyz.com semakin bertambah?*/
select quarter, count(distinct customerid) as total_customers
from (select customerid, createDate, quarter(createDate) quarter
	  from customer
) tabel_b
where createDate between '2004-01-01' and '2004-06-30'
group by quarter;

/* Question 4: Seberapa banyak customer tersebut yang sudah melakukan transaksi? */
select quarter, count(distinct customerid) total_customers
from (select customerid, createdate, quarter(createdate) quarter 
from customer
where createdate between '2004-01-01' and '2004-06-30') tabel_b

where customerid in(select distinct(customerid) from orders_1
union
select distinct(customerid) from orders_2)
group by quarter;

/* Question 5: Category produk apa saja yang paling banyak di order oleh customers di Q2? */
select *
from (
  select categoryid, count(distinct ordernumber) total_order, sum(quantity) total_penjualan
  from (
	select productcode, ordernumber, quantity, status, left(productcode,3) categoryid
	from orders_2
	where status = "Shipped") tabel_c
  group by categoryid) b
order by total_order desc;

/* Question 6: Berapa banyak cust yang tetap aktif bertransaksi setelah transaksi pertamanya? */
#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25


SELECT
 	'1' AS quarter,
  	COUNT(DISTINCT customerID) * 100 / 25  AS  q2
FROM
 	orders_1
WHERE
 	customerID IN
 	(
    SELECT
     	DISTINCT customerID
    FROM
     	orders_2
 );
