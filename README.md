Weather Info App
================

This application retrieves historical weather data for a given location and date range using the Open-Meteo API. If the data is already stored in the database, it will fetch it from there; otherwise, it makes an HTTP request to the Open-Meteo API.

Features
--------

*   API to fetch historical weather data based on location and date range.
*   Uses the Open-Meteo API to retrieve weather information.
*   Stores retrieved weather data in the database for faster future access.

Prerequisites
-------------

Make sure you have the following installed on your system:

1.  **Ruby**: Version 3.x or higher.
2.  **Rails**: Version 7.x or higher.
3.  **SQLite3** (or another database if configured differently in the project).
4.  **Git**: To clone the repository.
    

Setup Instructions
------------------

### 1\. Clone the Repository

```bash
git clone <This repository url>
cd backend-weather-app-openmeteo
```

### 2\. Install Dependencies

```bash
bundle install
```    

### 3\. Set Up the Database

```bash
rails db:create
rails db:migrate
```

### 4\. Start the Server
Preferably in a different port, as the frontend will be in port 3000.
The frontend is ready to receive from port 10524, so:

```bash
rails server -p 10524
```

API Endpoints
------------------
### GET /weather/historical?location=&start_date=&end_date=
Fetch historical weather data for a specific location and date range.

Response:
```json
[
    {
        "id": Numeric,
        "location": String,
        "date": Date,
        "temperature": Float?,
        "precipitation": Float?,
        "created_at": Datetime,
        "updated_at": Datetime
    }
]
```

Notes
------------------
Due to time constraints, additional enhancements (e.g., more robust error handling, more features) didn't come to fruition:
- A route to return a list of locations with the name of the user's input location - To be able to choose the correct one in the frontend