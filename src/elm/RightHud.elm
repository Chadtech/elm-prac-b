module RightHud exposing (rightHud)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import ReadOut          exposing (readOut)
import List             exposing (concat, map)
import String           exposing (slice, length)

rightHud : Model -> Html Msg
rightHud m = 
  div
  [ class "right-hud" ]
  [ miniMap m
  , readOut m.ship
  ]

miniMap : Model -> Html Msg
miniMap m =
  let
    s  = m.ship 
    xm = 
      (s.gx * 0.00185) - 111
    ym = 
      (s.gy * 0.00185) - 111
  in
  div
  [ class "mini-map-container" ]
  [ concat 
    [ (map drawThing m.things)
    , [ "./stars/real-stars.png"
        |>image 160 125
        |>toForm
        |>alpha 0.1
        |>rotate (degrees 0)
        |>move (-50, 0)
      , "./ship/ship.png"
        |>image 1 1
        |>toForm
        |>move (xm, ym)
      ]
    ]
    |>collage 222 222 
    |>toHtml
  ]

drawThing : Thing -> Form
drawThing t =
  let 
    xm = 
      (t.gx * 0.00185) - 111
    ym = 
      (t.gy * 0.00185) - 111
  in
  t.sprite.src
  |>image 1 1
  |>toForm
  |>move (xm, ym)