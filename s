import requests

def fetch_api_data(bearer_token, api_url):
    """
    Fetch data from the given API using a Bearer token.
    
    :param bearer_token: str, Bearer token for authentication
    :param api_url: str, API endpoint URL
    :return: dict or None, Response body as a JSON object or None if an error occurs
    """
    headers = {
        "Authorization": f"Bearer {bearer_token}",
        "Content-Type": "application/json"
    }
    
    try:
        response = requests.get(api_url, headers=headers)
        response.raise_for_status()  # Raise an HTTPError for bad responses (4xx and 5xx)
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data: {e}")
        return None

# Example usage
if __name__ == "__main__":
    token = "your_bearer_token_here"
    api_endpoint = "https://example.com/api/v1/resource"
    
    data = fetch_api_data(token, api_endpoint)
    if data:
        print("API Response:", data)
    else:
        print("Failed to fetch data.")
