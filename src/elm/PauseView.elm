module PauseView exposing (pausedNotice, pauseSign)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types        exposing (..)
import Components   exposing (point)

pausedNotice : Bool -> Html Msg
pausedNotice paused =
  if paused then
    div
    [ class "paused-notice" ]
    [ point "PAUSED" ]
  else
    span [] []

pauseSign : Html Msg
pauseSign = 
  div 
  [ class "pause" ] 
  [ point "P to pause"] 