
use Hotels;

--top 5 row from table
select top(5)* from data2018;
----------------------------------------------------------------------------------------------------------------------
--إجمالي الحجوزات  -
-- Total Of Booking
select distinct hotel,count(reservation_status_date) as total_booking 
from data2018 group by hotel;

--الحجوزات المؤكدة
-- Total Confirmed Booking
select distinct hotel,count(reservation_status_date) as total_booking 
from data2018 where is_canceled = 0 group by hotel;

--الحجوزات الملغاة
-- Total Cancelled Booking
select distinct hotel,count(reservation_status_date) as total_booking 
from data2018 where is_canceled = 1 group by hotel;

--إجمالي الليالي المحجوزة
--قياس حجم الإقامة 
-- Total Booking Nights
select hotel,count(stays_in_weekend_nights)+count(stays_in_week_nights) as reservation_nights
from data2018 group by hotel;

--متوسط مدة الإقامة
--فهم قيمة كل حجز وتشغيل الفندق
-- Avrage Days Of Staying At Hotel
select hotel,(count(stays_in_weekend_nights)+count(stays_in_week_nights))/count(reservation_status_date) as avg_stays
from data2018 group by hotel;




--متوسط السعر اليومي 
--Average daily price
select hotel,avg(adr) from data2018 group by hotel;

--الإيراد الحجوزي التقريبي
--Estimated booking revenue
select hotel,(count(stays_in_weekend_nights)+count(stays_in_week_nights)) * adr as Total_Cash 
from data2018 group by hotel;

--الإيراد المحقق التقريبي
--Approximate realized revenue
select hotel,(count(stays_in_weekend_nights)+count(stays_in_week_nights)) * adr as Total_Cash2 
from data2018 where is_canceled =1 group by hotel;



 
 --نسبة العملاء المتكررين
 --قياس الولاء
-- Percentage Of Repeat Customer
select hotel,cast(round(COUNT(CASE WHEN is_repeated_guest = 1 THEN 1 END) * 1.0
    / NULLIF(COUNT(reservation_status_date),0),2) as decimal(11,2)) AS Loyalty_Customer
FROM data2018 group by hotel;

--مجموع الطلبات الخاصة
-- Average Of Spacial Request
select hotel,sum(total_of_special_requests) as special_requests FROM data2018
group by hotel;

--متوسط فترة الحجز المسبق
-- Average Advance Booking Period In Days
select hotel,avg(lead_time) as special_requests FROM data2018
group by hotel;



--معدل الإلغاء الكلي حسب الفندق والشهر وشريحة السوق.
-- Overall Cancellation Rate By Hotel, Month, And Market Segment 
SELECT
    hotel,
    arrival_date_month,
    market_segment,
    cast(round(COUNT(CASE WHEN is_canceled = 1 THEN 1 END) *1.0
        / NULLIF(COUNT(reservation_status_date), 0),2)as decimal(12,2)) AS Avg_Cancelation
FROM data2018
GROUP BY
    hotel,
    arrival_date_month,
    market_segment
ORDER BY
    hotel,
    arrival_date_month,
    market_segment;


--معدل الإلغاء حسب القناة والوكيل.
-- Cancellation Rate By Channel And Agent
SELECT
    agent,
    customer_type,
    cast(round(COUNT(CASE WHEN is_canceled = 1 THEN 1 END) *1.0
        / NULLIF(COUNT(reservation_status_date), 0),2)as decimal(12,2)) AS Avg_Cancelation2
FROM data2018
GROUP BY
    agent,
  customer_type
ORDER BY
    agent,
    customer_type;

--معدل الإلغاء للعملاء الذين لديهم إلغاءات سابقة.
-- Cancellation Rate For Customers Who Have Had Previous Cancellations
SELECT
    hotel,
    cast(round(COUNT(CASE WHEN is_canceled = 1 THEN 1 END) *1.0
        / NULLIF(COUNT(reservation_status_date), 0),2)as decimal(12,2)) AS Avg_Cancelation3
FROM data2018 where previous_cancellations =1
GROUP BY
  hotel
ORDER BY
    hotel;

--معدل الإلغاء حسب نوع الإيداع (deposit_type).
-- Cancellation Rate By Deposit Type
SELECT
    deposit_type,
    cast(round(COUNT(CASE WHEN is_canceled = 1 THEN 1 END) *1.0
        / NULLIF(COUNT(reservation_status_date), 0),2)as decimal(12,2)) AS Avg_Cancelation4
FROM data2018 
GROUP BY
  deposit_type
ORDER BY
    deposit_type;

--قيمة الإيراد المعرضة للخطر
-- وتحسب تقريباً من
--adr × إجمالي الليالي للحجوزات الملغاة
--Total revenue value at risk
SELECT 
    hotel,SUM(CASE WHEN is_canceled = 1 THEN adr * stays_in_week_nights+stays_in_weekend_nights ELSE 0 END)
    AS Total_Sales
FROM 
    data2018 group by hotel;   

--متوسط الأيام بين الحجز والوصول للحجوزات الملغاة مقارنة بغير الملغاة.
-- Average Number Of Days Between Booking And Arrival For Cancelled and Uncancelled Bookings
select is_canceled,avg(lead_time) as avg_lead_time_by_canceled_status
from data2018 group by is_canceled; 

--معدل الإلغاء شهرياً.
-- Monthly Cancellation Rate
select arrival_date_month,count(is_canceled) as cancelation_by_month
from data2018 where is_canceled = 1 group by arrival_date_month
order by cancelation_by_month desc;

