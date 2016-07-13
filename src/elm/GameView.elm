module GameView exposing (gameView)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import Types            exposing (..)
import DrawShip         exposing (drawShip)
import List             exposing (filter, map, concat, foldr)
import Debug            exposing (log)


gameView : Model -> Html Msg
gameView m =
  collage 600 600 
  [ layerer
    [ area m
      |>populateArea m
      |>positionArea m.ship
      |>backdrop     m.ship
      |>drawMarkers  m
      |>rotateArea   m.ship
    , drawShip       m.ship.thrusters 
    ]
  ]|>toHtml

drawMarkers : Model -> Form -> Form
drawMarkers m area =
  let sg = (m.ship.gx, m.ship.gy)
  in
  layerer 
  <|concat
    [ [area] 
    , m.things
      |>filter (nearEnoughToMark m.ship.sector)
      |>map (drawMark sg) 
    ]

drawMark : (Float, Float) -> Thing -> Form
drawMark (sgx, sgy) t =
  let 
    dx = sgx - t.gx
    dy = sgy - t.gy
    dir = atan2 dx dy
  in
  "./ship/lander-gear.png"
  |>image 20 20 
  |>toForm
  |>move ((sin dir) * -300, (cos dir) * -300)

nearEnoughToMark : (Int, Int) -> Thing -> Bool
nearEnoughToMark (sx,sy) t =
  let
    (tx, ty) = t.sector
    dx = abs (sx - tx)
    dy = abs (sy - ty)
    nearEnoughX = dx < 5 && 1 < dx
    nearEnoughY = dy < 5 && 1 < dy
  in 
  nearEnoughX || nearEnoughY

layerer : List Form -> Form
layerer = toForm << collage 1200 1200

backdrop : Ship -> Form -> Form
backdrop s area =
  let
    x' = (-s.gx * 0.005) + 100
    y' = (-s.gy * 0.005) + 275
  in
    layerer
    [ "./stars/real-stars.png" 
      |>image 320 250
      |>toForm
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
      |>filter (nearEnoughToRender (q, ss))
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
    image w h sprite
    |>toForm
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

nearEnoughToRender : (Quadrant, (Int, Int)) -> Thing -> Bool
nearEnoughToRender (q,(sx,sy)) t =
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
  "./stars/stars.png"
  |>image 601 601
  |>toForm
  |>move pos




