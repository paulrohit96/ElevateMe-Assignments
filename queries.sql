CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    city VARCHAR(50),
    room_price DECIMAL(10,2),
    number_of_nights INT,
    customer_id INT,
    booking_date DATE,
    property_id INT,
    booking_status VARCHAR(20), -- confirmed/cancelled
    revenue DECIMAL(12,2) -- optional pre-calculated column
);

INSERT INTO bookings VALUES
(1, 'Delhi', 2000, 3, 101, '2024-01-15', 501, 'confirmed', 6000),
(2, 'Delhi', 1500, 2, 102, '2024-02-12', 502, 'confirmed', 3000),
(3, 'Mumbai', 2500, 4, 103, '2024-02-20', 503, 'cancelled', 10000),
(4, 'Mumbai', 1800, 1, 104, '2024-03-05', 504, 'confirmed', 1800),
(5, 'Bangalore', 3000, 2, 105, '2024-03-10', 505, 'confirmed', 6000),
(6, 'Delhi', 1200, 1, 106, '2024-04-01', 501, 'cancelled', 1200),
(7, 'Bangalore', 2200, 3, 107, '2024-04-15', 505, 'confirmed', 6600),
(8, 'Mumbai', 2000, 2, 108, '2024-05-01', 503, 'confirmed', 4000),
(9,  'Delhi', 1800, 2, 101, '2024-05-10', 501, 'confirmed', 3600),
(10, 'Delhi', 2200, 3, 102, '2024-06-15', 502, 'cancelled', 6600),
(11, 'Delhi', 2000, 1, 103, '2024-07-20', 501, 'confirmed', 2000),
(12, 'Delhi', 2500, 2, 104, '2024-08-12', 502, 'confirmed', 5000),
(13, 'Delhi', 1500, 5, 105, '2024-09-18', 501, 'confirmed', 7500),
(14, 'Mumbai', 3000, 3, 106, '2024-06-10', 503, 'confirmed', 9000),
(15, 'Mumbai', 2500, 2, 107, '2024-07-14', 504, 'confirmed', 5000),
(16, 'Mumbai', 2000, 4, 108, '2024-08-25', 503, 'cancelled', 8000),
(17, 'Mumbai', 2800, 3, 109, '2024-09-05', 504, 'confirmed', 8400),
(18, 'Mumbai', 2200, 2, 110, '2024-10-15', 503, 'confirmed', 4400),
(19, 'Bangalore', 2700, 2, 111, '2024-05-25', 505, 'confirmed', 5400),
(20, 'Bangalore', 2600, 1, 112, '2024-06-18', 505, 'cancelled', 2600),
(21, 'Bangalore', 3200, 3, 113, '2024-07-22', 505, 'confirmed', 9600),
(22, 'Bangalore', 2000, 2, 114, '2024-08-09', 505, 'confirmed', 4000),
(23, 'Bangalore', 2500, 4, 115, '2024-09-28', 505, 'confirmed', 10000),
(24, 'Chennai', 1800, 3, 116, '2024-05-30', 506, 'confirmed', 5400),
(25, 'Chennai', 2000, 2, 117, '2024-06-25', 506, 'confirmed', 4000),
(26, 'Chennai', 2200, 2, 118, '2024-07-19', 506, 'cancelled', 4400),
(27, 'Chennai', 2500, 1, 119, '2024-08-11', 506, 'confirmed', 2500),
(28, 'Chennai', 2800, 3, 120, '2024-09-29', 506, 'confirmed', 8400);


select city, SUM(room_price * number_of_nights) as Total_Revenue 
from bookings 
group by city;

--------

SELECT customer_id
FROM bookings
WHERE booking_date >= DATEADD(year, -1, GETDATE())
GROUP BY customer_id
HAVING COUNT(*) > 3;

------------------
SELECT property_id,
       (SUM(CASE WHEN booking_status = 'cancelled' THEN 1 ELSE 0 END) * 1.0 / COUNT(*))*100 AS cancellation_rate
FROM bookings
GROUP BY property_id;

-----------------------
WITH monthly_revenue AS (
    SELECT 
        city,
        FORMAT(booking_date, 'yyyy-MM') AS month,
        SUM(revenue) AS monthly_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY city 
            ORDER BY SUM(revenue) DESC
        ) AS rn
    FROM bookings
    GROUP BY city, FORMAT(booking_date, 'yyyy-MM')
)
SELECT city, month, monthly_revenue
FROM monthly_revenue
WHERE rn = 1;

-----------------------------------------------------
