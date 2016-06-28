module GameView exposing (gameView)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import DrawShip         exposing (drawShip)
import List             exposing (filter)

import Debug exposing (log)

gameView : Model -> Html Msg
gameView m =
  collage 600 600 
  [ layerer
    [ area m
      |>positionArea m.ship
      |>rotateArea   m.ship
    , drawShip       m.ship.thrusters 
    ]|>toForm
  ]|>toHtml

layerer : List Form -> Element
layerer = collage 1200 1200

nearEnough : (Quadrant, (Int, Int)) -> Thing -> Bool
nearEnough (q,(sx,sy)) t =
  let
    (tx, ty) = t.sector

    dx = sx - tx
    dy = sy - ty

    ex = \i -> dx == 0 || dx == i
    ey = \i -> dy == 0 || dy == i
  in
  case q of
    A -> if ex 1  && ey 1  then True else False
    B -> if ex -1 && ey 1  then True else False
    C -> if ex -1 && ey -1 then True else False
    D -> if ex 1 && ey -1 then True else False

area : Model -> Form
area m = 
  let
    q  = m.ship.quadrant
    ss = m.ship.sector

    ts = 
      filter (nearEnough (q, ss)) m.things

    ye = log "THINGS" ((q, ss), ts)
    --we = log "SECTORS" (

  in
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

--tile : (Int, Int) -> 

tile : String -> Form
tile t =
  toForm <| image 601 601 t

stars : Form
stars = tile "./stars/stars.png"