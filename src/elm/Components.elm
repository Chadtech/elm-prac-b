module Components exposing (..)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
--import Graphics.Collage exposing (..)
--import Graphics.Element exposing (..)
import Types            exposing (..)
import Styles           exposing (..)
import Json.Decode      as Json


onKeyDown : (Int -> Msg) -> Attribute Msg
onKeyDown msg =
  on "keydown" <|Json.map msg keyCode

