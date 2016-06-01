module DrawShip exposing (drawShip)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)


imager : Int -> Int -> String -> Form
imager w h str =
  toForm <| image w h str

drawShip : Ship -> Form
drawShip s =
  toForm
  <|collage 138 138
    [ imager 47 48 "./ship/ship.png" ]