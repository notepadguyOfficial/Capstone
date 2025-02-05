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
    - Run the SQL scripts located in the sql directory to set up the necessary tables.

## Configuration

1. **Environment Variables:**
    - Update the .env file with your configuration settings.

## Usage

1. **Start the application:**
    ```bash
    npm start
    ```
    or
    ```bash
    nodemon app.js
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

3. **Access the application:**
   - The application will be accessible on the forwarded ports specified in the  file.