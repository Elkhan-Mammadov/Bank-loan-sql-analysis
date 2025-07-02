
--Analysis of active loans: remaining amounts, last payments, overdue days, and risk levels

select
c.customer_id,
c.name ,
l.loan_id,
l.loan_amount,
l.interest_rate,
l.start_date,
l.due_date,
round(l.loan_amount - nvl(sum(lp.payment_amount),0),2) as remaining_amount,
max(lp.payment_date) as last_payment_date,
case when sysdate > l.due_date then trunc(sysdate - l.due_date)
else 0  end as overdue_days,
case
when sysdate > l.due_date and trunc(sysdate - l.due_date) >= 90 then 'high'
when sysdate > l.due_date and trunc(sysdate - l.due_date) between 30 and 89 then 'medium'
else 'low' end as risk_level
from
customers c join loans l on c.customer_id = l.customer_id
left join loan_payments lp on l.loan_id = lp.loan_id

where l.status = 'active'

group by c.customer_id,c.name,l.loan_id,l.loan_amount,l.interest_rate,l.start_date,l.due_date

order by risk_level desc,overdue_days desc;



--Total amount paid and calculated interest for each customer and their loans

select
c.name,
l.loan_id,
sum(lp.payment_amount) as total_paid,
round(l.loan_amount *(l.interest_rate/100),2) as expected_interest

from customers c join loans l on c.customer_id = l.customer_id
left join loan_payments lp on l.loan_id = lp.loan_id

group by c.name, l.loan_id, l.loan_amount, l.interest_rate;



--Customers with no payments in the last 30 days

select
c.customer_id,
c.name

from customers c join loans l on c.customer_id = l.customer_id
left join loan_payments lp on l.loan_id = lp.loan_id

where l.start_date < sysdate - 30

group by c.customer_id, c.name

having max(lp.payment_date) < sysdate - 30 or max(lp.payment_date) is null;


