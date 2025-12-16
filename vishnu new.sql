use mark_vishnu;

show tables from mark_vishnu;

alter table marketing_details rename column ï»¿age to age;

select * from marketing_details;

desc marketing_details;
# 1.Campaign success rate summary
/*total contacts*/
select count(contact) as total_contact from marketing_details;

/*total successfull deposit*/
Select deposit, count(*) AS total_deposit
 from  marketing_details where deposit='yes' group by deposit;

Select count(deposit)as total_deposit from  marketing_details;


    /*success rate=successful/total*/
select sum(case when deposit = 'yes' then 1 else 0 end) as successful,
    count(*) AS total,
    sum(case when deposit = 'yes' then 1 else 0 end) * 1.0 / count(*) as success_rate
from marketing_details;

#2.age group segmentation
/*Young,middle age, senior*/
select age,
case
when age between 18 and 30 then 'young'
when age between 31 and 55 then 'middle age'
else 'senior'
end as age_segment
from marketing_details;

/*total deposits*/
select age,count(deposit)as total_deposit 
from  marketing_details group by age ;

/*total customers*/
select age,count(age)as total_customer from  marketing_details group by age;


select
    age,
    avg(deposit) as AverageDepositRate
from
    marketing_details
group by
    age;
    
/*deposit rate per age segment.*/
select   case
        when age between 18 and 30 then 'Young'
        when age between 31 and 55 then 'Middle Age'
        when age >= 56 then 'Senior'
        else 'Unknown'
    end as age_group,
    round(sum(case when deposit = 'yes' then 1 else 0 end) * 1.0 
        / count(*),
        2
    ) as deposit_rate
from marketing_details
group by age_group
order by age_group;

/*3.Job category performance*/
Select
    job,
    count(*) as total_customers_contacted,
    sum(case when deposit = 'yes' then 1 else 0 end) as successful_deposits,
    #avg account balance sort by highest deposit conversation
    avg(balance) as avg_account_balance,
    round(
       sum(case when deposit = 'yes' then 1 else 0 end) * 1.0 / COUNT(*),
        4
    ) as deposit_conversion_rate
from marketing_details
group by job
order by deposit_conversion_rate DESC;

#4.Housing & loan impact
/*total customers*/
Select housing ,loan,count(*) as total_customers
from marketing_details group by housing,loan;

/*deposit success count*/
Select deposit,housing,loan, count(*) as deposit_success from  marketing_details where deposit='yes' 
group by deposit,housing,loan;

/* deposit success rate*/
select sum(case when deposit = 'yes' then 1 else 0 end) as successful,
    count(*) AS total,
    sum(case when deposit = 'yes' then 1 else 0 end) * 1.0 / count(*) as deposit_success_rate
from marketing_details
group by housing,loan;

#5. Education level analysis
select education,avg(balance) as avg_balance,
    sum(case when deposit = 'yes' then 1 else 0 end) as successful_deposits,
    count(*) as contact_count,
    
    round(
        sum(case when deposit = 'yes'  then 1 else 0 end) * 1.0 / count(*),
        4
    ) as deposit_success_rate

from marketing_details
group by education
order by deposit_success_rate DESC;

select age,avg(balance)as avg_balance,count('deposit'='yes') as count_deposit 
from marketing_details group by age;

#6.Contact method efficiency
/*average call duration & avg no.of.contacts(campaign)*/
select contact,avg(duration)as avg_duration ,avg(campaign) as avg_campaign from marketing_details
group by contact;

/*total deposits & success rate*/
select
    coalesce(contact, 'unknown') as contact_type,

    sum(case when deposit = 'yes' then 1 else 0 end) as total_deposits,

    round(
        sum(case when deposit = 'yes' then 1 else 0 end) * 1.0 / count(*),
        4
    ) as success_rate
from marketing_details
group by coalesce(contact, 'unknown')
order by success_rate DESC;

#7.RE-CONTACT BEHAVIOUR (pdays&poutcome)
select
    # Condition 1: contacted in a previous campaign
    SUM(CASE WHEN pdays > 0 THEN 1 ELSE 0 END) AS customers_contacted_before,
    SUM(CASE WHEN pdays > 0 AND deposit = 'yes' THEN 1 ELSE 0 END) AS success_pdays,
    SUM(CASE WHEN pdays > 0 AND deposit = 'yes' THEN 1 ELSE 0 END) * 1.0 /
        NULLIF(SUM(CASE WHEN pdays > 0 THEN 1 ELSE 0 END), 0)
        as pdays_success_rate,

    # Condition 2: customers with previous > 0
    SUM(case when previous > 0 then 1 else 0 end) as customers_with_previous_attempts,
    SUM(case when previous > 0 and deposit = 'yes' then 1 else 0 end) as success_previous,
    SUM(case when previous > 0 and deposit = 'yes' then 1 else 0 end) * 1.0 /
        NULLIF(SUM(case when previous > 0 then 1 else 0 end), 0)
        as previous_success_rate
from marketing_details;

#8.Time Based Campaign Performance
/*numbers of customers contacted*/
select contact,count(`age`) as customers from marketing_details group by `contact`;

/*average call duration*/
select avg(duration) as avg_duration from marketing_details;

/*total deposit,success rate*/
select coalesce(contact, 'unknown') as contact_type,

    sum(case when deposit = 'yes' then 1 else 0 end) as total_deposits,
    round(sum(case when deposit = 'yes' then 1 else 0 end) * 1.0 / count(*),4) as success_rate
    
from marketing_details

group by coalesce(contact, 'unknown')

order by success_rate DESC;

#9.high-value Customers 
/*find customer wit balance >5000 or,duration >200 seconds*/
select age,job,balance,duration,deposit
from marketing_details
where balance > 5000 or duration > 200
order by balance DESC;

#10.outcome analyze based on previous campaign
select coalesce(poutcome, 'unknown') as previous_outcome,count(*) as total_contacts,
     sum(case when deposit = 'yes' THEN 1 ELSE 0 END) AS successful_deposits,
    sum(case when deposit = 'yes' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) as success_rate
from marketing_details
group by coalesce(poutcome, 'unknown')order by success_rate DESC;
