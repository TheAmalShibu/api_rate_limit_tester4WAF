#!/bin/bash

# Ask the user for the URL
read -p "Enter the URL: " url

# Counter for the number of requests
count=0

# Function to make a curl request
make_request() {
    # Increment the request count
    ((count++))
    
    # Make the request and store the HTTP status code and response body
    response=$(curl -s -w "\nHTTP_STATUS:%{http_code}" $1)
    
    # Extract the HTTP status code from the response
    http_status=$(echo "$response" | tr -d '\n' | sed -e 's/.*HTTP_STATUS://')
    
    # Extract the body from the response
    body=$(echo "$response" | sed -e 's/HTTP_STATUS:.*//g')
    
    # Check for a successful response (status code 200)
    if [ "$http_status" -eq 200 ]; then
        echo "Request $count: Success (HTTP Status: $http_status)"
        echo "Response Body: $body"
        
        # Optionally, you can introduce a delay to avoid overwhelming the server or network
        #sleep 1
        
        # Make the next request
        make_request $1
    else
        # If the response is not successful, print the status and stop
        echo "Request $count: Failure (HTTP Status: $http_status)"
        echo "Response Body: $body"
    fi
}

# Start making requests
make_request $url
