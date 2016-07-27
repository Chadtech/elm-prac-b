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
view model = 
  let {ship, died, deathMsg} = model in
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
      [ gameView model
      , navMarkers model
      , velocityGauge ship
      , paused model.paused
      , diedNotice died deathMsg
      ]
    , rightHud model
    ]
  ]

