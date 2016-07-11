module MiniMap exposing (miniMap)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import List             exposing (concat, map)

miniMap : Model -> Html Msg
miniMap m =
  let s  = m.ship in
  div
  [ class "mini-map-container" ]
  [ concat 
    [ [ "./stars/real-stars.png"
        |>image 80 63
        |>toForm
        |>alpha 0.1
        |>rotate (degrees 0)
        |>move (-50, 0)
      , "./ship/ship.png"
        |>image 1 1
        |>toForm
        |>move (p s.gx, p s.gy)
      ]
    , (map drawThing m.things)
    ]
    |>collage 222 222 
    |>toHtml
  ]

drawThing : Thing -> Form
drawThing t =
  t.sprite.src
  |>image 1 1
  |>toForm
  |>move (p t.gx, p t.gy)

-- position in map 
p : Float -> Float
p f = (f * 0.00185) - 111