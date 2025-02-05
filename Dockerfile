# Use official Node.js image
FROM node:18

# Set the working directory
WORKDIR /workspace

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Install dependencies for the app
COPY package*.json ./
RUN npm install

# Copy the rest of the application source code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
