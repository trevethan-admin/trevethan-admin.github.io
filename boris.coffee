---
---

spinner = document.getElementById('spinner')
array = [ "My policy on cake is pro having it and pro eating it.",
          "I'm a one-nation Tory.",
          "Too full of drugs, obesity,  underachievement and Labour MPs.",
          "He's a rather engaging geezer",
          "I've slept with far fewer than 1,000",
          "No one obeys the speed limit except a motorised rickshaw.",
          "What has the BBC come to? Toilets, that's what",
          "Exams work because they're scary",
          "A horse is a safer bet than the trains",
          "Face it: it's all your own fat fault"
        ]
geo_options = {
  enableHighAccuracy: true,
  maximumAge : 30000,
  timeout : 27000
}
markerArray = []

init = () ->
  document.title = '"' + array[Math.floor(Math.random()*array.length)] + '"'

getBoris = () ->
  spinner.addClass('spin')
  number = event.target.dataset.number || 0
  type   = event.target.className
  tflAjax(type, number)

tflAjax = (type, number) ->
  $.ajax({
    type: "GET",
    dataType: "xml",
    url: "http://www.tfl.gov.uk/tfl/syndication/feeds/cycle-hire/livecyclehireupdates.xml"
  }).done((xml) -> geoFindMe(xml, type, number))

geoFindMe = (xml, type, number) ->
  navigator.geolocation.getCurrentPosition(success, error, geo_options)

sucess = (position) ->
  latitude  = position.coords.latitude
  longitude = position.coords.longitude
  altitude  = position.coords.altitude
  accuracy  = position.coords.accuracy
  getClosest(xml, latitude, longitude, type, number)

getClosest = (xml, latitude, longitude, type, number) ->
  stations = xml.getElementsByTagName('station')
  array    = []
  for i in [0..(stations.length - 1)]
    nbBikes      = parseInt(stations[i].getElementsByTagName('nbBikes')[0].childNodes[0].textContent)
    nbEmptyDocks = parseInt(stations[i].getElementsByTagName('nbEmptyDocks')[0].childNodes[0].textContent)
    lat          = parseFloat(stations[i].getElementsByTagName('lat')[0].childNodes[0].textContent)
    long         = parseFloat(stations[i].getElementsByTagName('long')[0].childNodes[0].textContent)
    dSquared     = Math.pow((latitude - lat), 2) + Math.pow((longitude - long), 2)
    id           = i

    if type == "bikes"
      if nbBikes > number
        array.push([dSquared,id])

    else if type == "spaces"
      if nbEmptyDocks > number
        array.push([dSquared,id])

    else
      array.push(id)

    if type == "random"
      id   = array[Math.floor(Math.random()*array.length)]
      lat  = parseFloat(stations[id].getElementsByTagName('lat')[0].childNodes[0].textContent)
      long = parseFloat(stations[id].getElementsByTagName('long')[0].childNodes[0].textContent)
      initialize(latitude, longitude, lat, long)
      return

    id   = indexOfSmallest(array)
    lat  = parseFloat(stations[id].getElementsByTagName('lat')[0].childNodes[0].textContent)
    long = parseFloat(stations[id].getElementsByTagName('long')[0].childNodes[0].textContent)
    initialize(latitude, longitude, lat, long)

indexOfSmallest = (a) ->
  lowest = 0
  for i in [1..(a.length - 1)]
    if a[i][0] < a[lowest][0]
      lowest = i
    return a[lowest][1]

error = (error) ->
  alert("Unable to retrieve your location due to "+error.code + " : " + error.message)

initialize = (latitude, longitude, lat, long) ->
  directionsService = new google.maps.DirectionsService()
  center            = new google.maps.LatLng(latitude, longitude)
  mapOptions        = {
    zoom: 15,
    center: center
  }
  map               = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)
  rendererOptions   = {
    map: map
  }
  directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions)
  stepDisplay       = new google.maps.InfoWindow()

  calcRoute(latitude, longitude, lat, long)

calcRoute = (latitude, longitude, lat, long) ->
  for i in [0..(markerArray.length - 1)]
    markerArray[i].setMap(null)

  markerArray = [];
  start       = latitude + "," + longitude;
  end         = lat + "," + long;
  request     = {
    origin: start,
    destination: end,
    travelMode: google.maps.TravelMode.WALKING
  }

  directionsService.route(request, (response, status) ->
    if status == google.maps.DirectionsStatus.OK
      warnings           = document.getElementById('warnings_panel')
      warnings.innerHTML = '<b>' + response.routes[0].warnings + '</b>'

      directionsDisplay.setDirections(response)
      showSteps(response)
  )

showSteps = (directionResult) ->
  myRoute = directionResult.routes[0].legs[0]
  for i in [0..(myRoute.steps.length - 1)]
    marker = new google.maps.Marker({
      position: myRoute.steps[i].start_location,
      map: map
    })
    attachInstructionText(marker, myRoute.steps[i].instructions)
    markerArray[i] = marker
    spinner.removeClass('spin')

attachInstructionText = (marker, text) ->
  google.maps.event.addListener(marker, 'click', () ->
    stepDisplay.setContent(text)
    stepDisplay.open(map, marker)
  )

init()
