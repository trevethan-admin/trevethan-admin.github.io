---
---

init = () ->

  # url = escape("http://api.qrserver.com/v1/create-qr-code/?data=HelloWorld")
  url = "http%3A%2F%2Fapi.qrserver.com%2Fv1%2Fcreate-qr-code%2F%3Fdata%3DHelloWorld"
  $.ajax({
    type: "GET",
    dataType: 'jsonp',
    url: "http://api.qrserver.com/v1/read-qr-code/?fileurl=#{url}",
    }).done(response).fail(fail)

response = (params) ->
  debugger

fail = () ->
  debugger

init()

