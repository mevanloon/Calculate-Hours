(function() {
  var app = Application('Calendar')
	app.includeStandardAdditions = true
	
  var requestedCalendar = app.chooseFromList(getCalendars(), {withTitle: 'What calendar should I search in?'})

	var requestedTerm = app.displayDialog('What term would you like to use to count hours?', {defaultAnswer: ''}).textReturned
	
	function getCalendars() {
		return app.calendars().map(n => n.name())
	}
	function getCalendar(requestedCalendar) {
	  var cal
		app.calendars().map(val => (val.name() == requestedCalendar ? cal = val : ''))
		return cal
	}
	function getEvents(requestedTerm, cal) {
	  var events = []
		Progress.totalUnitCount = cal.events().length
		Progress.completedUnitCount = 0
		
		cal.events().map(function(val) {
			Progress.completedUnitCount++
			if(val.summary().match(requestedTerm)) {
				events.push((val.endDate() - val.startDate()) / 1000 / 60 / 60)
			}
		})
		return events
	}
	function getTotalHours(events) {
		var total = 0
		events.map(i => total += i)
		
		return total
	}
	
	var events = getEvents(requestedTerm, getCalendar(requestedCalendar))
	var totalHours = getTotalHours(events)
	var resultString = `${totalHours} hours spent, spread amongst ${events.length} items. Requested term was '${requestedTerm}'`
	
	app.displayAlert(resultString)
	
	return resultString
})()