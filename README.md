# Customer-Inviter-Api

# Customer Inviter API

This is a Rails API that reads a `customers.txt` file and outputs a list of customers who are within 100km of our Mumbai office.

## Requirements

- Ruby `~> 3.0`
- Bundler `~> 2.2`

## Setup

1.  **Clone the repo:**
    ```bash
    git clone <your-repository-url>
    cd customer_inviter
    ```

2.  **Install dependencies:**
    ```bash
    bundle install
    ```

## Usage

-   **To run the server:**
    ```bash
    rails server
    ```
    The API will be available at `http://localhost:3000`.

-   **To run the tests:**
    ```bash
    bundle exec rspec
    ```

## API Endpoint

### `POST /api/v1/invite`

This endpoint finds customers to invite. The request must be `multipart/form-data`.

#### **Request Body**

The request requires one parameter:

-   `customers_file`: The text file containing customer data.

#### **Input File Format (`customers.txt`)**

The file should contain one JSON object per line. Each object needs `user_id`, `name`, `latitude`, and `longitude`.

```json
{"latitude": "19.0760", "user_id": 12, "name": "Christina McArdle", "longitude": "72.8777"}
{"latitude": "18.9667", "user_id": 1, "name": "Alice Cahill", "longitude": "72.8333"}
{"latitude": "28.644800", "user_id": 15, "name": "Bob Stuart (Far Away)", "longitude": "77.216721"}

Example cURL Request
curl -X POST \
  -F "customers_file=@customers.txt" \
  http://localhost:3000/api/v1/invite

Responses
Success (200 OK)
Returns a JSON array of customers within 100km, sorted by user_id.

[
  {
    "user_id": 1,
    "name": "Alice Cahill"
  },
  {
    "user_id": 12,
    "name": "Christina McArdle"
  }
]

Error (400 Bad Request)
Returns an error if the customers_file is not provided.

{
  "error": "File not provided. Please upload using the `customers_file` parameter."
}

