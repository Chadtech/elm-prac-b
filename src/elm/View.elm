module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import GameView         exposing (gameView)
import RightHud         exposing (rightHud)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)

view : Model -> Html Msg
view model = 
  div
  [ class "root" ]
  [ div 
    [ class "main" ]
    [ div
      [ class "left-hud" ]
      [ "./key-diagram.png" 
        |>image 156 131
        |>toHtml
      ]
    , div 
      [ class "game-view" ] 
      [ gameView model ]
    , rightHud model
    ]
  ]
