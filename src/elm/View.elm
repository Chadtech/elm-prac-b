module View exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
--import Syles           exposing (..)
import Components       exposing (..)
import GameView         exposing (gameView)


view : World -> Html Msg
view world = 
  div
  [ class "game" ]
  [ gameView world ]  
  --[ div 
  --  [ class "view-port" ] 
  --  [ gameView world ]
  --]









