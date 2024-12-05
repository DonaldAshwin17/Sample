import requests
from requests.auth import HTTPBasicAuth

def get_access_token():
    url = "https://url.url.com/openam/oauth2/access_token"
    params = {
        "grant_type": "client_credentials"
    }
    data = {
        "scope": "api.dispute-matter.v1 api.dispute-matter.matters.read api.dispute-matter.matters.write "
                 "api.dispute-matter.matters.source api.dispute-matter.matters.source--panda-api "
                 "api.dispute-matter.datalake.read api.edmpanda.v1"
    }
    headers = {
        "Content-Type": "application/x-www-form-urlencoded"
    }
    auth = HTTPBasicAuth("client_id", "client_password")
    
    response = requests.post(url, params=params, data=data, headers=headers, auth=auth)
    return response.json()

# Example usage
if __name__ == "__main__":
    token_response = get_access_token()
    print(token_response)
