Batman.mixin Batman.Filters,

  startText: (str_start)->
    now = moment.utc()
    start = moment.unix(str_start)
    if start.diff(now, 'minutes') < 10 && start.diff(now, 'minutes') > -5
      el = document.getElementsByClassName('google_calendar_work')[0]
      el.style.animation = ''
      el.style.animation = 'pulse 1s ease 55 alternate'
    "#{start.from(now)}"

class Dashing.GoogleCalendar extends Dashing.Widget
