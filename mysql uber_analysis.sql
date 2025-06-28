mysql> SHow databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sakila             |
| strava_fitness     |
| sys                |
| uber               |
| world              |
+--------------------+
8 rows in set (0.00 sec)

mysql> use uber;
Database changed

mysql> CREATE TABLE uber_analysis (
    ->     Request_id INT,
    ->     Pickup_point VARCHAR(20),
    ->     Driver_id INT,
    ->     Status VARCHAR(50),
    ->     Request_timestamp DATETIME,
    ->     Drop_timestamp DATETIME
    -> );
Query OK, 0 rows affected (0.04 sec)

mysql>
mysql> LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Uber Request Data.csv'
    -> INTO TABLE uber_analysis
    -> FIELDS TERMINATED BY ','
    -> OPTIONALLY ENCLOSED BY '"'
    -> LINES TERMINATED BY '\r\n'
    -> IGNORE 1 ROWS
    -> (Request_id, Pickup_point, @Driver_id, Status, @Request_timestamp, @Drop_timestamp)
    -> SET
    ->     Driver_id = NULLIF(@Driver_id, ''),
    ->     Request_timestamp = STR_TO_DATE(NULLIF(@Request_timestamp, 'nan'), '%d-%m-%Y %H:%i:%s'),
    ->     Drop_timestamp = STR_TO_DATE(NULLIF(@Drop_timestamp, 'nan'), '%d-%m-%Y %H:%i:%s');
Query OK, 6745 rows affected (0.23 sec)
Records: 6745  Deleted: 0  Skipped: 0  Warnings: 0

mysql> SELECT * FROM uber_analysis
    -> LIMIT 10;
+------------+--------------+-----------+----------------+---------------------+---------------------+
| Request_id | Pickup_point | Driver_id | Status         | Request_timestamp   | Drop_timestamp      |
+------------+--------------+-----------+----------------+---------------------+---------------------+
|        619 | Airport      |         1 | Trip Completed | 2016-07-11 11:51:00 | 2016-07-11 13:00:00 |
|        867 | Airport      |         1 | Trip Completed | 2016-07-11 17:57:00 | 2016-07-11 18:47:00 |
|       1807 | City         |         1 | Trip Completed | 2016-07-12 09:17:00 | 2016-07-12 09:58:00 |
|       2532 | Airport      |         1 | Trip Completed | 2016-07-12 21:08:00 | 2016-07-12 22:03:00 |
|       3112 | City         |         1 | Trip Completed | 2016-07-13 08:33:16 | 2016-07-13 09:25:47 |
|       3879 | Airport      |         1 | Trip Completed | 2016-07-13 21:57:28 | 2016-07-13 22:28:59 |
|       4270 | Airport      |         1 | Trip Completed | 2016-07-14 06:15:32 | 2016-07-14 07:13:15 |
|       5510 | Airport      |         1 | Trip Completed | 2016-07-15 05:11:52 | 2016-07-15 06:07:52 |
|       6248 | City         |         1 | Trip Completed | 2016-07-15 17:57:27 | 2016-07-15 18:50:51 |
|        267 | City         |         2 | Trip Completed | 2016-07-11 06:46:00 | 2016-07-11 07:25:00 |
+------------+--------------+-----------+----------------+---------------------+---------------------+
10 rows in set (0.00 sec)

mysql> SELECT COUNT(*) AS total_rows FROM uber_analysis;
+------------+
| total_rows |
+------------+
|       6745 |
+------------+
1 row in set (0.01 sec)

mysql> SELECT COUNT(*) AS null_driver_ids
    -> FROM uber_analysis
    -> WHERE Driver_id IS NULL;
+-----------------+
| null_driver_ids |
+-----------------+
|            2650 |
+-----------------+
1 row in set (0.01 sec)

mysql> SELECT `Status`, COUNT(*) AS total_requests
    -> FROM uber_analysis
    -> GROUP BY `Status`
    -> ORDER BY total_requests DESC
    -> LIMIT 15;
+-------------------+----------------+
| Status            | total_requests |
+-------------------+----------------+
| Trip Completed    |           2831 |
| No Cars Available |           2650 |
| Cancelled         |           1264 |
+-------------------+----------------+
3 rows in set (0.01 sec)

mysql>
mysql> SELECT HOUR(Request_timestamp) AS request_hour, COUNT(*) AS total_requests
    -> FROM uber_analysis
    -> GROUP BY request_hour
    -> ORDER BY request_hour
    -> LIMIT 15;
+--------------+----------------+
| request_hour | total_requests |
+--------------+----------------+
|            0 |             99 |
|            1 |             85 |
|            2 |             99 |
|            3 |             92 |
|            4 |            203 |
|            5 |            445 |
|            6 |            398 |
|            7 |            406 |
|            8 |            423 |
|            9 |            431 |
|           10 |            243 |
|           11 |            171 |
|           12 |            184 |
|           13 |            160 |
|           14 |            136 |
+--------------+----------------+
15 rows in set (0.01 sec)

mysql> SELECT Pickup_point, COUNT(*) AS total_pickups
    -> FROM uber_analysis
    -> GROUP BY Pickup_point
    -> LIMIT 15;
+--------------+---------------+
| Pickup_point | total_pickups |
+--------------+---------------+
| Airport      |          3238 |
| City         |          3507 |
+--------------+---------------+
2 rows in set (0.01 sec)

mysql> SELECT Pickup_point, Status, COUNT(*) AS total_requests
    -> FROM uber_analysis
    -> GROUP BY Pickup_point, Status
    -> ORDER BY Pickup_point, total_requests DESC
    -> LIMIT 15;
+--------------+-------------------+----------------+
| Pickup_point | Status            | total_requests |
+--------------+-------------------+----------------+
| Airport      | No Cars Available |           1713 |
| Airport      | Trip Completed    |           1327 |
| Airport      | Cancelled         |            198 |
| City         | Trip Completed    |           1504 |
| City         | Cancelled         |           1066 |
| City         | No Cars Available |            937 |
+--------------+-------------------+----------------+
6 rows in set (0.01 sec)

mysql> SELECT Status, COUNT(*) AS total_requests
    -> FROM uber_analysis
    -> GROUP BY Status
    -> LIMIT 15;
+-------------------+----------------+
| Status            | total_requests |
+-------------------+----------------+
| Trip Completed    |           2831 |
| Cancelled         |           1264 |
| No Cars Available |           2650 |
+-------------------+----------------+
3 rows in set (0.01 sec)

mysql> SELECT DATE(Request_timestamp) AS request_date, COUNT(*) AS total_requests
    -> FROM uber_analysis
    -> GROUP BY request_date
    -> ORDER BY request_date
    -> LIMIT 15;
+--------------+----------------+
| request_date | total_requests |
+--------------+----------------+
| 2016-07-11   |           1367 |
| 2016-07-12   |           1307 |
| 2016-07-13   |           1337 |
| 2016-07-14   |           1353 |
| 2016-07-15   |           1381 |
+--------------+----------------+
5 rows in set (0.01 sec)

mysql> SELECT HOUR(Request_timestamp) AS request_hour, COUNT(*) AS demand_count
    -> FROM uber_analysis
    -> GROUP BY request_hour
    -> ORDER BY request_hour
    -> LIMIT 15;
+--------------+--------------+
| request_hour | demand_count |
+--------------+--------------+
|            0 |           99 |
|            1 |           85 |
|            2 |           99 |
|            3 |           92 |
|            4 |          203 |
|            5 |          445 |
|            6 |          398 |
|            7 |          406 |
|            8 |          423 |
|            9 |          431 |
|           10 |          243 |
|           11 |          171 |
|           12 |          184 |
|           13 |          160 |
|           14 |          136 |
+--------------+--------------+
15 rows in set (0.01 sec)

mysql> SELECT
    ->   HOUR(Request_timestamp) AS request_hour,
    ->   SUM(CASE WHEN Status = 'Trip Completed' THEN 1 ELSE 0 END) AS available,
    ->   SUM(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 ELSE 0 END) AS not_available
    -> FROM uber_analysis
    -> GROUP BY request_hour
    -> ORDER BY request_hour
    -> LIMIT 15;
+--------------+-----------+---------------+
| request_hour | available | not_available |
+--------------+-----------+---------------+
|            0 |        40 |            59 |
|            1 |        25 |            60 |
|            2 |        37 |            62 |
|            3 |        34 |            58 |
|            4 |        78 |           125 |
|            5 |       185 |           260 |
|            6 |       167 |           231 |
|            7 |       174 |           232 |
|            8 |       155 |           268 |
|            9 |       173 |           258 |
|           10 |       116 |           127 |
|           11 |       115 |            56 |
|           12 |       121 |            63 |
|           13 |        89 |            71 |
|           14 |        88 |            48 |
+--------------+-----------+---------------+
15 rows in set (0.01 sec)

mysql> SELECT
    ->   HOUR(Request_timestamp) AS request_hour,
    ->   COUNT(*) AS total_requests,
    ->   SUM(CASE WHEN Status = 'Trip Completed' THEN 1 ELSE 0 END) AS completed,
    ->   SUM(CASE WHEN Status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled,
    ->   SUM(CASE WHEN Status = 'No Cars Available' THEN 1 ELSE 0 END) AS no_cars
    -> FROM uber_analysis
    -> GROUP BY request_hour
    -> ORDER BY request_hour
    -> LIMIT 15;
+--------------+----------------+-----------+-----------+---------+
| request_hour | total_requests | completed | cancelled | no_cars |
+--------------+----------------+-----------+-----------+---------+
|            0 |             99 |        40 |         3 |      56 |
|            1 |             85 |        25 |         4 |      56 |
|            2 |             99 |        37 |         5 |      57 |
|            3 |             92 |        34 |         2 |      56 |
|            4 |            203 |        78 |        51 |      74 |
|            5 |            445 |       185 |       176 |      84 |
|            6 |            398 |       167 |       145 |      86 |
|            7 |            406 |       174 |       169 |      63 |
|            8 |            423 |       155 |       178 |      90 |
|            9 |            431 |       173 |       175 |      83 |
|           10 |            243 |       116 |        62 |      65 |
|           11 |            171 |       115 |        15 |      41 |
|           12 |            184 |       121 |        19 |      44 |
|           13 |            160 |        89 |        18 |      53 |
|           14 |            136 |        88 |        11 |      37 |
+--------------+----------------+-----------+-----------+---------+
15 rows in set (0.01 sec)

mysql> SELECT
    ->   HOUR(Request_timestamp) AS request_hour,
    ->   SUM(CASE WHEN Status IN ('Cancelled', 'No Cars Available') THEN 1 ELSE 0 END) AS frustrated_users
    -> FROM uber_analysis
    -> GROUP BY request_hour
    -> ORDER BY frustrated_users DESC
    -> LIMIT 15;
+--------------+------------------+
| request_hour | frustrated_users |
+--------------+------------------+
|           18 |              346 |
|           20 |              331 |
|           19 |              307 |
|           21 |              307 |
|            8 |              268 |
|           17 |              267 |
|            5 |              260 |
|            9 |              258 |
|            7 |              232 |
|            6 |              231 |
|           22 |              150 |
|           10 |              127 |
|            4 |              125 |
|           23 |               91 |
|           13 |               71 |
+--------------+------------------+
15 rows in set (0.01 sec)

mysql>