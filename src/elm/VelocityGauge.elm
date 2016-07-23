module VelocityGauge exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (point)
import GameView         exposing (gameView)
import RightHud         exposing (rightHud)
import NavMarkers       exposing (navMarkers)
import String           exposing (slice)
import Debug exposing (log)


velocityGauge : Ship -> Html Msg
velocityGauge s =
  let
    (vx, vy) = s.velocity
    v = (sqrt (vx^2 + vy^2))/10
    urgency = 
      if 15 > v then ""
      else
        if 30 > v then "urgent"
        else 
          if 45 > v then "urgenter"
          else "critical"
  in
  div
  [ class "velocity-gauge" ]
  [ point "speed" 
  , p
    [class ("point " ++ urgency) ]
    [ text
      <|slice 0 5
      <|toString v
    ]
  ]
