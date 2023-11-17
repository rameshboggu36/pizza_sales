use pizza_sales;

select * from pizza_sales;

# total number of entries in the dataset
select count(*) from pizza_sales;


##############################################################################################
								  # KEY MTERICS 
###############################################################################################
#Total Revenue ==  sum of the total_price column will give the total revenue

select ROUND(sum(total_price),2) as 'Total Revenue' from pizza_sales;

#Total orders == order_id column has duplicate values as each order can contain different pizzas, so we need distinct order_id
# to get the total orders

select count(distinct(order_id)) as 'Total Orders' from pizza_sales;

#Average Order Value ==  total revenue divided by total orders will give the average value

select round(sum(total_price)/count(distinct(order_id)),4) as 'Average Order Value' from pizza_sales;

#Total Pizzas sold  == sum of the quantity will give total pizzas quantity

select sum(quantity) as 'Total Number of Pizzas sold' from pizza_sales;

#Average Pizzas per order  == total quantity of pizzas divided by total orders will give avg pizzas per order

select round(sum(quantity)/count(distinct(order_id)),3) as 'Average Pizzas per Order' from pizza_sales;

######################################################################################################
						#TRENDS DAILY/MONTHLY
######################################################################################################

#Daily trend == number of orders made on each day

select dayname(str_to_date(order_date,'%d-%m-%Y')) as ' Day Name',count(distinct(order_id)) as 'Total Orders'
from pizza_sales 
GROUP BY dayname(str_to_date(order_date,'%d-%m-%Y'))
order by count(distinct(order_id)) desc;

#Monthly trend == number of orders made per each month 

select monthname(str_to_date(order_date,'%d-%m-%Y')) as ' Day Name',count(distinct(order_id)) as 'Total Orders'
from pizza_sales 
GROUP BY monthname(str_to_date(order_date,'%d-%m-%Y'))
order by count(distinct(order_id)) desc;


# Percentage of revenue by pizza category

with total_revenue(tot_rev) as
(select sum(total_price) from pizza_sales)
select p.pizza_category as 'Pizza Category', round(sum(p.total_price),2) as 'Category revenue', round(sum(p.total_price)*100 / tr.tot_rev, 4) as 'Percentage revenue'
from pizza_sales p, total_revenue tr
group by p.pizza_category,tr.tot_rev
order by round(sum(p.total_price) / tr.tot_rev, 4)*100 desc;

# Percentage of revenue by pizza size

with total_revenue(tot_rev) as
(select sum(total_price) from pizza_sales)
select p.pizza_size as 'Pizza Size', round(sum(p.total_price),2) as 'Pizza Size revenue', round(sum(p.total_price)*100 / tr.tot_rev, 4) as 'Percentage revenue'
from pizza_sales p, total_revenue tr
group by p.pizza_size,tr.tot_rev
order by round(sum(p.total_price) / tr.tot_rev, 4)*100 desc;


# percentage of orders by pizza category

with total_orders(tot_ord) as
(select sum(quantity) from pizza_sales)
select p.pizza_category as 'Pizza_category',sum(p.quantity) as 'orders by Category',round(sum(p.quantity)*100/tor.tot_ord,4) as 'Percentage Orders'
from pizza_sales p, total_orders tor
group by p.pizza_category, tor.tot_ord
order by round(sum(p.quantity)*100/tor.tot_ord,4) desc;

# percentage of orders by pizza size

with total_orders(tot_ord) as
(select sum(quantity) from pizza_sales)
select p.pizza_size as 'Pizza_category',sum(p.quantity) as 'orders by Category',round(sum(p.quantity)*100/tor.tot_ord,4) as 'Percentage Orders'
from pizza_sales p, total_orders tor
group by p.pizza_size, tor.tot_ord
order by round(sum(p.quantity)*100/tor.tot_ord,4) desc;


#########################################################################################
					#TOP and WORST SELLERS based on REVENUE and QUANTITY
#########################################################################################

#Top 5 best sellers based on Revenue

with category_revenue(pizza_name,revenue) as
(select pizza_name,sum(total_price) from pizza_sales group by pizza_name)
select *,
rank() over(order by revenue desc) as 'ranking'
from category_revenue
limit 5;


#Bottom 5 worst sellers based on Revenue

with category_revenue(pizza_name,revenue) as
(select pizza_name,round(sum(total_price)) from pizza_sales group by pizza_name)
select *,
rank() over(order by revenue) as 'ranking'
from category_revenue
limit 5;

#Top 5 best sellers based on Quantity

with category_quantity(pizza_name,quantity) as
(select pizza_name,sum(quantity) from pizza_sales group by pizza_name)
select *,
rank() over(order by quantity desc) as 'ranking'
from category_quantity
limit 5;

#Bottom 5 worst sellers based on Quantity

with category_quantity(pizza_name,quantity) as
(select pizza_name,sum(quantity) from pizza_sales group by pizza_name)
select *,
rank() over(order by quantity) as 'ranking'
from category_quantity
limit 5;


#Top 5 best sellers based on no.of Orders

with category_orders(pizza_name,no_of_orders) as
(select pizza_name,count(DISTINCT order_id) from pizza_sales group by pizza_name)
select *,
rank() over(order by no_of_orders desc) as 'ranking'
from category_orders
limit 5;

#Bottom 5 worst sellers based on no.of Orders

with category_orders(pizza_name,no_of_orders) as
(select pizza_name,count(DISTINCT order_id) from pizza_sales group by pizza_name)
select *,
rank() over(order by no_of_orders) as 'ranking'
from category_orders
limit 5;