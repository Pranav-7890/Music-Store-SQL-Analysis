create database music;

use music;

-- ------------------------------------------1. Easy Level Queries
-- Q1: Find the most senior employee based on job title. 
SELECT
    first_name,  -- Employee's first name
    last_name,   -- Employee's last name
    title,       -- Job title of the employee
    levels       -- Seniority level (higher value = more senior)
FROM
    employee     -- Source table containing employee records
ORDER BY
    levels DESC  -- Sort employees from highest to lowest seniority
LIMIT 1;         -- Return only the most senior employee


-- Q2: Determine which countries have the most invoices.
SELECT 
    billing_country,          -- Country where the invoice was billed
    COUNT(*) AS Invoice_count -- Total number of invoices per country
FROM    
    music.invoice             -- Invoice table in the music schema
GROUP BY 
    billing_country           -- Aggregate invoices by country
ORDER BY 
    Invoice_count DESC        -- Sort countries by invoice count (highest first)
LIMIT 1;                      -- Return only the country with the most invoices


-- Q3: Identify the top 3 invoice totals. 
SELECT *                     -- Retrieve all columns for each invoice
FROM music.invoice           -- Invoice table in the music schema
ORDER BY total DESC          -- Sort invoices by total amount (highest first)
LIMIT 3;                     -- Return the top 3 highest-value invoices


-- Q4: Find the city with the highest total invoice amount to determine the best location for a promotional event. 
SELECT 
    billing_city,
    billing_state,
    billing_country,
    ROUND(SUM(total),2) AS Total_Sales   -- Total sales per location
FROM music.invoice
GROUP BY 
    billing_city,
    billing_state,
    billing_country
ORDER BY 
    Total_Sales DESC            -- Highest sales first
LIMIT 1;                        -- Top location only



-- Q5: Identify the customer who has spent the most money.
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(i.total), 2) AS total_sales  -- Total amount spent by customer
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY 
    total_sales desc         -- Highest spender first
LIMIT 1;                     -- Single customer



-- ---------------------------------------2. Moderate Level Queries

-- q1
SELECT first_name, last_name, email
FROM customer c
JOIN invoice i 
ON c.customer_id = i.customer_id
JOIN invoice_line il
ON i.invoice_id = il.invoice_id
JOIN Track t
ON il.track_id = t.track_id
JOIN genre g
ON t.genre_id = g.genre_id
where g.name = 'Rock'				-- Only Rock genre purchases
GROUP BY  c.first_name, c.last_name, c.email
ORDER BY c.first_name, c.last_name, c.email;


-- q2
SELECT
    a.name AS artist_name,
    COUNT(t.track_id) AS total_rock_tracks
FROM artist AS a
JOIN album2 AS al 
    ON a.artist_id = al.artist_id
JOIN track AS t 
    ON al.album_id = t.album_id
JOIN genre AS g 
    ON t.genre_id = g.genre_id
WHERE
    g.name = 'Rock'              -- Only Rock tracks
GROUP BY
    a.name
ORDER BY
    total_rock_tracks DESC        -- Most Rock tracks first
LIMIT 10;                         -- Top 10 artists


-- q3
SELECT
    name,
    milliseconds
FROM
    track
WHERE
    milliseconds > (              -- Only tracks longer than average
        SELECT AVG(milliseconds) 
        FROM track
    )
ORDER BY
    milliseconds DESC;            -- Longest tracks first



-- ------------------------------------------3. Advanced Level Queries
-- q1
WITH ArtistSales AS (
    -- Step 1: Compute total spent on each invoice line and link it to the artist
    SELECT
        il.invoice_id AS iid,                  -- Invoice ID
        al.artist_id AS aid,                   -- Artist ID
        il.unit_price * il.quantity AS lt      -- Line total (cost)
    FROM invoice_line AS il
    JOIN track AS tr 
        ON il.track_id = tr.track_id           -- Link invoice line to track
    JOIN album2 AS al 
        ON tr.album_id = al.album_id           -- Link track to album/artist
)
SELECT
    c.first_name AS fn,                        -- Customer first name
    c.last_name AS ln,                         -- Customer last name
    ar.name AS an,                             -- Artist name
    ROUND(SUM(asales.lt), 2) AS total_spent    -- Total spent by customer on this artist
FROM ArtistSales AS asales
JOIN invoice AS i 
    ON asales.iid = i.invoice_id               -- Link back to invoice for customer info
JOIN customer AS c
    ON i.customer_id = c.customer_id          -- Get customer details
JOIN artist AS ar
    ON asales.aid = ar.artist_id              -- Get artist details
GROUP BY
    c.customer_id, c.first_name, c.last_name, ar.name  -- Aggregate per customer and artist
ORDER BY
    c.last_name, total_spent DESC;            -- Sort by customer last name, then spending

    

-- q2
WITH CountryGenrePurchases AS (
    -- 1. Count sales for each genre in each country and rank them
    SELECT
        i.billing_country AS bc,         -- Country
        g.name AS gn,                    -- Genre name
        COUNT(il.invoice_line_id) AS pc, -- Purchase count
        ROW_NUMBER() OVER (
            PARTITION BY i.billing_country
            ORDER BY COUNT(il.invoice_line_id) DESC
        ) AS gr                         -- Rank genres within each country
    FROM invoice AS i
    JOIN invoice_line AS il 
        ON i.invoice_id = il.invoice_id  -- Link invoice to invoice line
    JOIN track AS t 
        ON il.track_id = t.track_id      -- Link invoice line to track
    JOIN genre AS g 
        ON t.genre_id = g.genre_id       -- Link track to genre
    GROUP BY i.billing_country, g.name
)
SELECT
    bc AS billing_country,
    gn AS genre_name,
    pc AS purchase_count
FROM CountryGenrePurchases
WHERE gr = 1       -- Keep only the top genre per country
ORDER BY pc desc;       -- Sort by country

    

-- q3
-- Q3: Identify the top-spending customer for each country
WITH CustomerCountrySpending AS (
    -- 1. Calculate total spending per customer per country and rank them
    SELECT
        c.customer_id AS cid,                  -- Customer ID
        c.first_name AS fn,                    -- First name
        c.last_name AS ln,                     -- Last name
        c.country AS cn,                       -- Customer country
        ROUND(SUM(i.total), 2) AS ts,          -- Total spent
        ROW_NUMBER() OVER (
            PARTITION BY c.country
            ORDER BY SUM(i.total) DESC
        ) AS sr                                 -- Rank customers within country
    FROM customer AS c
    JOIN invoice AS i 
        ON c.customer_id = i.customer_id       -- Link customer to invoices
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
)
SELECT
    cn AS country,
    fn AS first_name,
    ln AS last_name,
    ts AS total_spent
FROM CustomerCountrySpending
WHERE sr = 1        -- Keep only the top spender per country
ORDER BY ts desc;        -- Sort by country

