module PauseView exposing (paused, instructions)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types        exposing (..)
import Components   exposing (point, tinyPoint)

paused : Bool -> Html Msg
paused paused =
  if paused then
    div
    [ class "paused-notice" ]
    [ point "PAUSED" ]
  else span [] []

instructions : Html Msg
instructions = 
  div 
  [ class "pause" ] 
  [ tinyPoint "'P' to pause. Collect resources. Dont run out of air. Dont fly into the planet. Nav markers show nearby resrouces and point in their relative direction. Gray arrow is north. Blue arrow is your direction."]
