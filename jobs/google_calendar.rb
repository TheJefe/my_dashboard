require "google/apis/calendar_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

# Src: https://developers.google.com/calendar/quickstart/ruby

calendars = Hash[*File.read('gcal.config').split(/[, \n]+/)]
max_events = 3

OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
APPLICATION_NAME = "Dashing Personal Calendar".freeze
CREDENTIALS_PATH = "credentials.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  if credentials.nil?
    url = authorizer.get_authorization_url base_url: OOB_URI
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

def init
  # Initialize the API
  service = Google::Apis::CalendarV3::CalendarService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize
  return service
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  service = init()
  calendars.each do |cal_name, calendar_id|
    response = service.list_events(
      calendar_id,
      max_results:   max_events,
      single_events: true,
      order_by:      "startTime",
      time_min:      DateTime.now.rfc3339
    )
    events = response.items.each.map do |event|
      {
        title: event.summary,
        start: event.start.date || event.start.date_time.to_time.to_i,
        end: event.end.date || event.end.date_time.to_s
      }
    end
    puts "=====#{cal_name}======"
    send_event("google_calendar_#{cal_name}", {events: events, cal_name: cal_name})
  end
end
