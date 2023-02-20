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


/* Berdasarkan data yang telah kita peroleh melalui query SQL, Kita dapat menarik kesimpulan bahwa :
1. Performance xyz.com menurun signifikan di quarter ke-2, terlihat dari nilai penjualan dan revenue yang drop hingga 20% dan 24%,
2. perolehan customer baru juga tidak terlalu baik, dan sedikit menurun dibandingkan quarter sebelumnya.
3. Ketertarikan customer baru untuk berbelanja di xyz.com masih kurang, hanya sekitar 56% saja yang sudah bertransaksi. Disarankan tim Produk untuk perlu mempelajari behaviour customer dan melakukan product improvement, sehingga conversion rate (register to transaction) dapat meningkat.
4. Produk kategori S18 dan S24 berkontribusi sekitar 50% dari total order dan 60% dari total penjualan, sehingga xyz.com sebaiknya fokus untuk pengembangan category S18 dan S24.
5. Retention rate customer xyz.com juga sangat rendah yaitu hanya 24%, artinya banyak customer yang sudah bertransaksi di quarter-1 tidak kembali melakukan order di quarter ke-2 (no repeat order).
6. xyz.com mengalami pertumbuhan negatif di quarter ke-2 dan perlu melakukan banyak improvement baik itu di sisi produk dan bisnis marketing, jika ingin mencapai target dan positif growth di quarter ke-3. Rendahnya retention rate dan conversion rate bisa menjadi diagnosa awal bahwa customer tidak tertarik/kurang puas/kecewa berbelanja di xyz.com. */
