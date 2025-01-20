# 🎮 SQL Final Project: Video Games Sales Analysis

## 📚 Project Overview
This project involves analyzing a dataset of video game sales, ratings, and related metrics from 1980 to 2020. Using SQL, I performed data exploration and analysis to answer key business questions and uncover insights about the gaming industry's performance across different platforms, genres, and regions.

---

## 🛠️ Technologies Used
- **SQL Server**: Used to manage and query the database.
- **Excel**: Dataset imported from Excel into SQL Server.
- **SSMS**: SQL Server Management Studio for database operations and analysis.

---

## 📂 File Structure
SQL -Gaming Industry Sales Project.sql: Includes all SQL queries written to perform the analysis, such as weighted averages, YoY growth,and global sales by genre.

Video games sales dataset.xlsx: The dataset used for this project, including details on video games (sales, ratings, platforms, etc.).

---

## 🧩 Dataset Description
The dataset contains the following fields:
- **Game Metadata**:
  - Name, Platform, Year of Release, Genre, Publisher, Developer.
- **Sales Data**:
  - NA Sales, EU Sales, JP Sales, Other Sales, Global Sales (in millions).
- **Rating Data**:
  - Critic Score, Critic Count, User Score, User Count, ESRB Rating.

---

## 🗂️ Key Analyses
### 1. Business Questions
- Which year saw the highest number of genres at their peak?
- How many games were released on 3 or more platforms?

### 2. Statistical Analysis
- **Weighted Average, Mean, and Mode**:
  - Calculated for critic scores by rating.
  - Identified ratings with identical values across all measures and explained why.

### 3. Data Scaffolding
- Generated global sales by **Genre**, **Platform**, and **Year**.
- Filled missing combinations with zero values for consistency.

### 4. Year-over-Year Growth Analysis
- Performed a YoY analysis to identify the year with the highest growth rate in global sales for each platform.

---

## 💻 How to Run the Project
1. Import the `Video games sales dataset.xlsx` dataset into SQL Server.
   - Create a new database named `Video_Games`.
   - Import the data.
2. Run the queries in `SQL -Gaming Industry Sales Project.sql` to perform the analyses.
3. Use the scaffolding and growth analysis queries to generate additional insights.

---

## 🔑 Key Findings
- **Highest Genre Activity**:
  - The year with the most active genres was [INSERT FINDING].
- **Critic Scores**:
  - Two ratings had identical weighted average, mean, and mode values due to [INSERT REASON].
- **Top YoY Growth**:
  - The platform with the highest YoY growth was [INSERT PLATFORM] in [INSERT YEAR].

---

## 🚀 Future Enhancements
- Expand the dataset to include more recent data beyond 2020.
- Visualize key findings using Tableau or Python.
- Automate the analysis with stored procedures.

---

## 📧 Contact
For questions or feedback, feel free to reach out:
- Email: [Maor7878@gmail.com](mailto:Maor7878@gmail.com)
- LinkedIn: [Your LinkedIn Profile](https://www.linkedin.com/in/maor-barel-a823a3288/)
