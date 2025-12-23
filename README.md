# 🎵 Music Store Business Analysis (SQL)

## 📌 Project Overview
This project performs a deep-dive analysis of a fictional music store's database using MySQL. The goal is to transform raw data into actionable business intelligence by answering critical questions regarding customer growth, regional sales performance, and inventory optimization.

By executing complex SQL queries—ranging from basic aggregations to advanced **Window Functions** and **CTEs**—this analysis provides a data-driven roadmap for marketing and operational strategies.

## 🏗️ Dataset Structure
The database consists of 8 interconnected tables:

*   **Employee**: Staff details and seniority levels.
*   **Customer**: Contact info and geographic location.
*   **Invoice & Invoice_Line**: Detailed transaction records.
*   **Track, Album, Artist, & Genre**: Comprehensive music library metadata.

## 🚀 Key Business Insights
The analysis revealed several high-impact findings used to drive the company’s next quarterly strategy:

| Metric | Insight |
| :--- | :--- |
| **Top Market Opportunity** | **Prague** was identified as the city with the highest cumulative invoice totals, making it the primary target for promotional events. |
| **Customer Loyalty** | **František Wichterlová** was the highest-spending customer ($144.54), ideal for exclusive loyalty tiering. |
| **Regional Preferences** | Music tastes vary by border: **Canada** prefers Rock, while **Norway** leans toward Latin music. |
| **Inventory Focus** | The top 10 Rock artists were isolated to prioritize digital placement and restocking. |

## 🔍 SQL Techniques Used
The project is organized into three levels of complexity:

*   **Easy**: Basic filtering, sorting, and simple joins (e.g., finding the most senior employee).
*   **Moderate**: Multi-table joins and subqueries (e.g., identifying rock music fans and top artists).
*   **Advanced**: Recursive CTEs and Window Functions (e.g., calculating the top-spending customer per country and popular genres by region).

## 🛠️ How to Use
1.  **Clone the Repo**: 
    `git clone https://github.com/yourusername/Music-Store-SQL-Analysis.git`
2.  **Database Setup**: Import the files in the `/Dataset` folder into your MySQL Workbench.
3.  **Run Queries**: Open `Music_Database_Analysis.sql` and execute the queries to see the results.

## 📈 Conclusion
This project demonstrates the power of SQL in extracting meaningful business narratives from relational databases. The insights generated assist in optimizing marketing budgets, personalizing customer retention, and maximizing global revenue growth.
