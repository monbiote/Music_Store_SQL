# Music Store SQL Analysis

## By Edward Monbiot

## Overview
This project consists of a comprehensive SQL analysis focused on a music store database (`musicstore3`). It involves a series of queries that explore various aspects of the data, ranging from customer and invoice details to album and track information.

## Project Objectives
- Explore the music store database through various SQL queries.
- Analyze customer and employee data in relation to invoices generated.
- Study track durations, album genres, and artists' performance in terms of sales and popularity.

## Key Queries and Analyses
1. **Composer Track Count:** Counting the number of tracks composed by 'F. Baltes'.
2. **Invoice Analysis:** Analyzing the total number of invoices and those with a specific amount.
3. **Album and Artist Information:** Extracting the first five albums and their artists, sorted alphabetically.
4. **Customer and Employee Details:** Listing the first ten customers and their corresponding support representatives.
5. **Track Duration Analysis:** Identifying the five longest tracks along with detailed information.
6. **Most Expensive Albums:** Determining the top five most expensive albums based on cumulative unit price.
7. **Selective Album Pricing:** Finding albums with an average track price above a certain amount.
8. **Genre Diversity in Albums:** Identifying albums with more than one genre.
9. **Count of Eclectic Albums:** Calculating the total number of albums with diverse genres.
10. **Invoice Total Validation:** Ensuring invoice totals match the sum of their individual line items.
11. **Employee Performance Analysis:** Identifying top-performing employees based on invoice amounts generated.
12. **Average Expenses Metrics:** Calculating average expenses per customer, per invoice, and the average number of invoices per customer.
13. **Customers Above Average Expense:** Counting the number of customers spending above the average.
14. **Artist Popularity and Profitability:** Assessing artists based on the number of tracks sold, total revenue, and total purchased song minutes.

## Data Description
- The database `musicstore3` contains detailed information about tracks, albums, artists, customers, employees, and invoices.
- Data encompasses various entities of a music store, including sales, customer demographics, and music categorization.

## Repository Contents
- `Music_Store_SQL_Analysis.sql`: SQL queries performing the analysis.
- `musicstore_dump_efficient.sql`: Database dump file containing the structure and data of the `musicstore3` database.

## How to Use
- The SQL queries can be executed in any SQL database management system that supports MySQL.
- Import the `musicstore_dump_efficient.sql` file to your SQL server to create the `musicstore3` database.
- Run the queries in `Music_Store_SQL_Analysis.sql` against the `musicstore3` database to replicate the analysis.

## Future Work
- Extend the analysis to include time-series data of sales.
- Incorporate advanced SQL features like stored procedures and triggers for automated insights.

