# Capstone Project

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Codespaces](#codespaces)

## Introduction

Hydro App is a mobile platform designed to streamline sales, orders, delivery, and stock management, addressing inefficiencies in the current operations of water refilling stations. It aims to improve existing processes by automating manual tasks and providing real-time updates on key operational aspects. The platform will track sales, inventory levels, customer orders, and delivery routes using GPS tracking integrated with a two-dimensional scale map of *. These features will reduce errors associated with manual data entry and enable better resource allocation, ensuring that stations can meet customer demands more effectively.

## Features

- Account Management
- Product Management
- Inventory Management
- Order Management
- Delivery Optimization
- Walk-In Sales
- Payment Integration
- Reporting and Analytics
- Customer Interaction
- User-Friendly Interface
- Beta Testing Feedback

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/notepadguyOfficial/Capstone.git
   cd Capstone
   ```

2. **Install dependencies:**

    ```bash
    npm install
    ```

    (!Note)If you want to automatically save progress without restarting app
    ```bash
    npm install -g nodemon
    ```

3. **Set up the database:**
    - Ensure PostgreSQL is installed and running.
    - Create a new database.
    - Run the SQL scripts located in the `sql` directory to set up the necessary tables.
    - Use the `base.sql` file from the `sql` folder to restore the backup:
      ```bash
      psql -U your_username -d your_database -f sql/base.sql
      ```
    - Alternatively, you can query the code inside `base.sql` directly in your PostgreSQL client.

## 📘 API Status Codes
- The backend uses standard HTTP status codes along with some custom codes to provide more specific feedback.

### Success Responses

| Code | Meaning | Description |
|------|---------|-------------|
| 200  | OK      | Request was successful. |
| 201  | Created | Resource was successfully created. |

### ⚠️ Client Errors

| Code | Meaning                     | Description |
|------|-----------------------------|-------------|
| 400  | Bad Request                 | The request is malformed or invalid. |
| 401  | Unauthorized                | Authentication failed or missing. |
| 403  | Forbidden                   | You don’t have permission to access. |
| 404  | Not Found                   | Resource doesn’t exist. |
| 422  | Unprocessable Entity        | Validation error on input data. |
| 1001 | Username Already Exists     | A user tried to register an existing username. |
| 1002 | Phone Number Already Exists | A user tried to register an existing phone number. |
| 1003 | User Not Found              | The specified user was not found in the database. |
| 1004 | Invalid Password            | The password provided is incorrect. |

### Server Errors

| Code | Meaning               | Description                                |
|------|------------------------|--------------------------------------------|
| 500  | Internal Server Error | Unexpected condition encountered.          |

## Configuration

1. **Environment Variables:**
    - Update the .env file with your configuration settings.

## Usage

1. **Start the application:**
    ```bash
    npm run start #normal start
    ```
    or
    ```bash
    npm run dev #nodemon for development
    ```

2. **Access the application:**
    - Todo

## Tools
1. **Postman**
    - [Download Link](https://dl.pstmn.io/download/latest/win64)

## Codespaces

1. **Create a Codespace:**
   - Open the repository on GitHub.
   - Click on the `Code` button and select `Open with Codespaces`.
   - Follow the prompts to create a new Codespace.

2. **Launch the application:**
   - Once the Codespace is ready, open the terminal.
   - Run the following command to start the application:
     ```bash
     docker-compose up -d
     ```

3. **Stop the application:**
   - If you want to stop developing, run the following command:
     ```bash
     docker-compose down
     ```

4. **Access the application:**
   - The application will be accessible on the forwarded ports specified in the [devcontainer.json](http://_vscodecontentref_/1) file.