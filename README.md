Check out http://smashing.github.io/smashing for more information.

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
