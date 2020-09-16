Check out http://smashing.github.io/smashing for more information.

![image](https://user-images.githubusercontent.com/2390653/77599432-03457c00-6edb-11ea-8d79-de14d94d2ca9.png)

# Start

`smashing start`

# Start in the background

`smashing start -d`

Runs at: [http://localhost:3030](http://localhost:3030)

# Google Calendar Integration Setup

1. Goto https://developers.google.com/calendar/quickstart/ruby
2. Click "Enable the Google Calendar API"
3. Download credentials.json and include in this projects directory
4. Create `gcal.config` with the following

    ```
    work,my_work_email
    personal,my_personal_email
    ```
5. Updated `credentials.json` to match `gcal.config`. Example `credentials_work.json` and `credentials_personal.json`
6. When first run, you'll need to follow a URL output in the logs, and paste the token that you get back into the terminal

# Github Integration Setup

Create `github.config` with the following

```
token,my_github_api_token
query,is:open is:pr author:TheJefe user:my_org
```

# Weather Widget Setup
Get API key from https://openweathermap.org/
Drop it in `env.yml`

Example:
```yaml
openweathermap:
  api_key: 1234abc
  city_id: 12345
```
