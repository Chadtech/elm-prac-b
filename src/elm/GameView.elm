module GameView exposing (gameView)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import DrawShip         exposing (drawShip)
import List             exposing (filter, map)
import Pather           exposing (root)

gameView : Model -> Html Msg
gameView m =
  collage 600 600 
  [ layerer
    [ area m
      |>populateArea m
      |>positionArea m.ship
      |>backdrop     m.ship
      |>rotateArea   m.ship
    , drawShip       m.ship.thrusters 
    ]
  ]|>toHtml

layerer : List Form -> Form
layerer = toForm << collage 1200 1200

backdrop : Ship -> Form -> Form
backdrop s area =
  let
    x' = (-s.gx * 0.005) + 100
    y' = (-s.gy * 0.005) + 275
  in
  layerer
  [ "stars/real-stars" 
    |>image' 320 250
    |>alpha 0.1
    |>move (x', y')
  , area
  ]

positionArea : Ship -> Form -> Form
positionArea s area' = 
  layerer [ move (-s.x, -s.y) area' ]

rotateArea : Ship -> Form -> Form
rotateArea s area' =
  layerer [ rotate (degrees -s.a) area' ]

populateArea : Model-> Form -> Form
populateArea m area =
  let
    q  = m.ship.quadrant
    ss = m.ship.sector

    ts = 
      m.things
      |>filter (nearEnough (q, ss))
      |>map (adjustPosition (q, ss))
      |>map drawAt
      |>layerer

  in layerer [ area, ts ]

drawAt : ((Float, Float), Thing) -> Form
drawAt (p, t) =
  let
    w      = t.sprite.w
    h      = t.sprite.h
    sprite = t.sprite.src
  in
  image' w h sprite
  |>move p
  |>rotate (degrees t.a)

adjustPosition : (Quadrant, (Int, Int)) -> Thing -> ((Float, Float), Thing) 
adjustPosition (q,(sx,sy)) t = 
  let
    (tx, ty) = t.sector

    sameX = tx - sx == 0
    sameY = ty - sy == 0

    x' =
      case q of
        A -> if sameX then t.x - 600 else t.x
        B -> if sameX then t.x else t.x - 600
        C -> if sameX then t.x - 600 else t.x
        D -> if sameX then t.x else t.x - 600

    y' = 
      case q of
        A -> if sameY then t.y else t.y - 600
        B -> if sameY then t.y else t.y - 600
        C -> if sameY then t.y - 600 else t.y
        D -> if sameY then t.y - 600 else t.y

  in ((x', y'), t)

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
    A -> ex -1 && ey 1 
    B -> ex 1  && ey 1  
    C -> ex -1 && ey -1 
    D -> ex 1  && ey -1 


area : Model -> Form
area m = 
  layerer
  [ stars (-300, 300)  -- A
  , stars (300, 300)   -- B
  , stars (300, -300)  -- C
  , stars (-300, -300) -- D
  ]

stars : (Float, Float) -> Form
stars pos = 
  "stars/stars-1"
  |>image' 601 601
  |>move pos

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm
