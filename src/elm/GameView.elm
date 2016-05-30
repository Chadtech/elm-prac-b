module GameView exposing (gameView)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import DrawLander       exposing (drawLander)


gameView : World -> Html Msg
gameView world =
  layerer
  [ area
    |>positionArea world.frege
    |>rotateArea world.frege
  , drawLander world.frege
  ]
  |>toHtml

worldSize = (1200, 1200)

layerer : List Form -> Element
layerer = 
  let 
    (w, h) = worldSize
  in
    collage w h

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