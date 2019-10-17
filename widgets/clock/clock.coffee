class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    s = today.getSeconds()
    [h,meridiem] = @formatHour(h)
    m = @formatTime(m)
    s = @formatTime(s)
    @set('time', h + ":" + m + ":" + s + " " + meridiem)
    @set('date', today.toDateString())

  formatTime: (i) ->
    if i < 10 then "0" + i else i

  formatHour: (i) ->
    if i > 12
      return [i-12, 'pm']
    else
      return [i,'am']
