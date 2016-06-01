module GameView exposing (gameView)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import DrawShip         exposing (drawShip)


gameView : Ship -> Html Msg
gameView s =
  collage 600 600 
  [ layerer
    [ area
      |>positionArea s
      |>rotateArea   s
    , drawShip       s
    ]|>toForm
  ]|>toHtml

layerer : List Form -> Element
layerer = collage 1200 1200

area : Form
area =
  layerer
  [ move (-300, 300)  stars
  , move (300, 300)   stars
  , move (300, -300)  stars
  , move (-300, -300) stars
  ]
  |>toForm

positionArea : Ship -> Form -> Form
positionArea s area' = 
  layerer [ move (-s.x, -s.y) area' ]
  |>toForm

rotateArea : Ship -> Form -> Form
rotateArea s area' =
  layerer [ rotate (degrees -s.a) area' ]
  |>toForm

tile : String -> Form
tile t =
  toForm <| image 601 601 t

stars : Form
stars = tile "./stars/stars.png"