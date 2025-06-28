# 🚖 Uber Ride Request Data Analysis

This project focuses on analyzing Uber ride request data to identify demand-supply gaps, user frustrations, peak hours, and operational inefficiencies using a combination of **Excel**, **MySQL**, and **Python**. The aim is to extract meaningful insights that Uber can use to improve driver availability, reduce cancellations, and optimize ride allocations.

---

## 📌 Business Objective

To understand patterns in Uber’s ride request data, especially focusing on when and where demand exceeds supply, leading to high cancellation or unavailability rates. The ultimate goal is to recommend actionable solutions to improve customer satisfaction and operational efficiency.

---

## 📊 Tools & Technologies Used

- **Excel** – For initial data cleaning, formatting timestamps, and pre-analysis.
- **Python** – Libraries: `Pandas`, `Matplotlib`, `Seaborn` for EDA and visualization.
- **MySQL** – For relational querying, grouping, and aggregation analysis.

---

## 📁 Dataset Description

The dataset contains the following columns:

- `Request_id` – Unique ID of the request
- `Pickup_point` – Airport or City
- `Driver_id` – Driver's unique identifier (NaN if no driver assigned)
- `Status` – Completed / Cancelled / No Cars Available
- `Request_timestamp` – Time when the ride was requested
- `Drop_timestamp` – Time when the ride ended

---

## 📈 Visuals Included

1. **Total Request Status Distribution**  
2. **Total Ride Requests by Hour**  
3. **Pickup Point Distribution**  
4. **Ride Status by Pickup Point**  
5. **Ride Status Overall (Pie Chart)**  
6. **Requests Per Day**  
7. **Hourly Demand Patterns**  
8. **Demand vs Availability**  
9. **Hourly Trends: Completed, Cancelled, and No Cars**  
10. **User Frustration Analysis**

Each visual is implemented in both Python and MySQL with a unique Excel-based variant to compare approaches.

---

## 🧠 Key Insights

- Peak demand hours are between **5 AM–9 AM** and **5 PM–9 PM**.
- **City pickups** face more cancellations, especially in the morning.
- **Airport pickups** often result in "No Cars Available".
- There's a clear **mismatch between demand and supply** during rush hours.
- User frustration is highest in early morning hours due to lack of availability.

---

## ✅ Business Recommendations

- Increase driver incentives during peak hours in City pickups.
- Pre-allocate drivers near airports in early morning and evening windows.
- Use predictive analytics to forecast high-demand time slots and regions.
- Implement a "pre-book" feature to optimize ride allocations during peak.

---
