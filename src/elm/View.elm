module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import GameView         exposing (gameView)
import RightHud         exposing (rightHud)
import NavMarkers       exposing (navMarkers)
import VelocityGauge    exposing (velocityGauge)
import KeyDiagram       exposing (keyDiagram)
import Components       exposing (point)


view : Model -> Html Msg
view model = 
  div
  [ class "root" ]
  [ div 
    [ class "main" ]
    [ div
      [ class "left-hud" ]
      [ keyDiagram ]
    , div 
      [ class "game-view" ] 
      [ gameView model
      , navMarkers model
      , velocityGauge model.ship
      , pausedNotice model.paused
      ]
    , rightHud model
    ]
  ]


pausedNotice : Bool -> Html Msg
pausedNotice paused =
  if paused then
    div
    [ class "paused-notice" ]
    [ point "PAUSED" ]
  else
    div [] []