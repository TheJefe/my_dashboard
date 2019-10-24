require 'net/http'
require 'icalendar'
require 'open-uri'

# List of calendars
#
# Format:
#   <name> => <uri>
# Example:
#   hangouts: "https://www.google.com/calendar/ical/<hash>.calendar.google.com/private-<hash>/hangouts.ics"
calendars = Hash[*File.read('calendars.config').split(/[, \n]+/)]
max_events = 3

SCHEDULER.every '5m', :first_in => 0 do |job|

  calendars.each do |cal_name, cal_uri|

    ics  = open(cal_uri) { |f| f.read }
    cal = Icalendar::Calendar.parse(ics).first
    events = cal.events
    # events = events.first(100)

    # select only current and upcoming events
    now = DateTime.now.utc

    events = events.select  { |event| event.dtend.class == Icalendar::Values::DateTime  }
    events = events.select  { |event| event.dtstart.class == Icalendar::Values::DateTime  }

    events = events.select{ |e| DateTime.parse(e.dtend.to_s) > now }

    # select events for today
    events = events.select{ |e| DateTime.parse(e.dtend.to_s) > Date.today && DateTime.parse(e.dtend.to_s) < Date.tomorrow }

    # sort by start time
    events = events.sort{ |a, b| DateTime.parse(a.dtstart.to_s) <=> DateTime.parse(b.dtstart.to_s) }[0..(max_events-1)]


    events = events.map do |e|
      {
        title: e.summary,
        start: DateTime.parse(e.dtstart.to_s).to_i,
        end: DateTime.parse(e.dtend.to_s).to_i
      }
    end
    puts "**************#{events.count}***************"
    send_event("google_calendar_#{cal_name}", {events: events, cal_name: cal_name})
  end

end
