# _         = require 'lodash'
app       = Elm.Main.fullscreen()
{request} = app.ports


request.subscribe (thing) ->
  'this is a ' + thing

respond = (s) ->
  app.ports.response.send s // 1

document.addEventListener "visibilitychange", 
  ->
    if document.hidden
      app.ports.response.send false
  false
