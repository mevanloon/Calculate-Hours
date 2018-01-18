(function() {
  calendar = Application('Calendar')
  calendar.includeStandardAdditions = true

  var requestedCalendar = calendar.chooseFromList(calendar.calendars().map(c=>c.name()), {withTitle: 'What calendar should be searched for events?'})
  if(requestedCalendar === false) {
    return false
  }

  const requestedPeriod = calendar.displayDialog('What period should be used for the query?', {defaultAnswer: '2017-05-01 2017-12-31'}).textReturned
  if(requestedPeriod === false) {
    return false
  }

  var requestedTerm = calendar.displayDialog('What term would you like to use to count hours?', {defaultAnswer: ''}).textReturned
  if(requestedPeriod === false) {
    return false
  }

  const periods = requestedPeriod.match(/([0-9\-]+)\s([0-9\-]+)/)
  const periodStart = periods && periods.length === 3 ? new Date(periods[1]) : new Date(0)
  const periodEnd = periods && periods.length === 3 ? new Date(periods[2]) : new Date()

  const selectedCalendar = calendar.calendars[requestedCalendar]
  const numberOfEvents = selectedCalendar.events().length
  Progress.totalUnitCount = numberOfEvents
  Progress.completedUnitCount = 0

  const events = selectedCalendar.events()
    .filter(e => { Progress.completedUnitCount++; return e.startDate()/1 >= periodStart/1 && e.endDate()/1 <= periodEnd/1 })
    .map(e => { return new Date(e.endDate()/1 - e.startDate()/1)/1000/60/60 })

  const totalHours = events.reduce((a, e) => a+e)

  // Return the results
  var resultString = `${totalHours} hours spent, spread amongst ${numberOfEvents} items. Requested term was '${requestedTerm}'`

  calendar.displayAlert(resultString)

  return resultString
})()
