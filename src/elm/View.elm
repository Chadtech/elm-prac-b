module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import GameView         exposing (gameView)


view : Model -> Html Msg
view model = 
  div
  [ class "game" ]
  [ div 
    [ class "view-port" ] 
    [ gameView model.ship ]
  ]



