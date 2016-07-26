module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import GameView         exposing (gameView)
import RightHud         exposing (rightHud)
import NavMarkers       exposing (navMarkers)
import VelocityGauge    exposing (velocityGauge)
import KeyDiagram       exposing (keyDiagram, keyExample)
import PauseView        exposing (paused, instructions)
import DiedView         exposing (diedNotice)


view : Model -> Html Msg
view m = 
  div
  [ class "root" ]
  [ div 
    [ class "main" ]
    [ div
      [ class "left-hud" ]
      [ keyDiagram
      , instructions
      ]
    , keyExample
    , div 
      [ class "game-view" ] 
      [ gameView m
      , navMarkers m
      , velocityGauge m.ship
      , paused  m.paused
      , diedNotice    m.died m.deathMsg
      ]
    , rightHud m
    ]
  ]

