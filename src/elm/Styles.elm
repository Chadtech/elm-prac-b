module Styles exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (..)
import Types           exposing (..)

(-) = (,)

viewStyle : Attribute Msg
viewStyle =
  style
  [ "margin"  - "auto"
  , "width"   - "60%"
  , "padding" - "10px"
  , "background-color" - "#ff0000"
  , "height" - "500px"
  , "width" - "500px"
  , "position" - "relative"
  , "top" - "50%"
  , "transform" - "translateY(-50%)"
  , "overflow" - "hidden"
  ]

