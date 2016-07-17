module MiniMap exposing (miniMap)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import List             exposing (append, map)
import Pather           exposing (root)

miniMap : Model -> Html Msg
miniMap m =
  let s = m.ship in
  div
  [ class "mini-map-container" ]
  [ append
    [ root "stars/real-stars"
      |>image' 80 63
      |>alpha 0.1
      |>rotate (degrees 0)
      |>move (-50, 0)
    , root "ship/ship"
      |>image' 2 2
      |>move (p s.gx, p s.gy)
    , root "markers/yellow"
      |>image' 5 5
      |>move (p 60000, p 60000)
    ]
    (map drawThing m.things)
    |>collage 222 222 
    |>toHtml
  ]

drawThing : Thing -> Form
drawThing t =
  root t.sprite.src
  |>image' 2 2
  |>move (p t.gx, p t.gy)

-- position in map 
p : Float -> Float
p f = (f * 0.00185) - 111

image' : Int -> Int -> String -> Form
image' w h src = image w h src |> toForm