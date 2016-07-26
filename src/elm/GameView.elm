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
      |>farOffStars  m.ship
      |>rotateArea   m.ship
    , sky m.ship.global
    , drawShip       
        (m.ship.fuel > 0)
        m.ship.thrusters
    ]
  ]|>toHtml

layerer : List Form -> Form
layerer = toForm << collage 1200 1200

modulo : Int -> Float -> Float
modulo m f =
  let f' = floor f in
  (toFloat (f' % m)) + (f - (toFloat f'))

farOffStars : Ship -> Form -> Form
farOffStars s area =
  let
    (x,y) = s.global
    x'    = modulo 600 (x / 30)
    y'    = modulo 600 (y / 30)
    pos   = (300 - x', 300 - y')
  in
  layerer
  [ layerer
    [ smallStars (-300, 300)  -- A
    , smallStars (300, 300)   -- B
    , smallStars (300, -300)  -- C
    , smallStars (-300, -300) -- D
    ]|> move pos |> alpha 0.8 
    , area
  ]

backdrop : Ship -> Form -> Form
backdrop s area =
  let
    (x,y) = s.global
    x' = (-x * 0.005) + 100
    y' = (-y * 0.005) + 275
  in
  layerer
  [ "celestia/real-stars" 
    |>image' 320 250
    |>alpha 0.2
    |>move (x', y')
  , area
  ]

positionArea : Ship -> Form -> Form
positionArea s area' = 
  let (x,y) = s.local in
  layerer [ move (-x, -y) area' ]

rotateArea : Ship -> Form -> Form
rotateArea s area' =
  let a = fst s.angle in
  layerer [ rotate (degrees -a) area' ]

populateArea : Model-> Form -> Form
populateArea m area =
  let
    q  = m.ship.quadrant
    ss = m.ship.sector

    ts = 
      m.things
      |>filter (nearEnough m.ship.global)
      |>map (adjustPosition m.ship.global m.ship.local)
      |>map drawAt
      |>layerer

  in layerer [ area, ts ]

drawAt : (Coordinate, Thing) -> Form
drawAt (p, t) =
  let
    (w,h)  = t.sprite.dimensions
    sprite = t.sprite.src
    a      = fst t.angle
  in
  image' w h sprite
  |>move p
  |>rotate (degrees a)

adjustPosition : Coordinate -> Coordinate -> Thing -> (Coordinate, Thing)
adjustPosition (sgx, sgy) (slx, sly) t =
  let (tgx, tgy) = t.global in
  ((tgx  - sgx  + slx, tgy - sgy + sly), t)

nearEnough : Coordinate -> Thing -> Bool
nearEnough (sgx, sgy) t =
  let (tgx, tgy) = t.global in
  (sqrt ((sgx - tgx)^2 + (sgy - tgy)^2)) < 300

area : Model -> Form
area m = 
  layerer
  [ stars (-300, 300)  -- A
  , stars (300, 300)   -- B
  , stars (300, -300)  -- C
  , stars (-300, -300) -- D
  ]

smallStars : Coordinate -> Form
smallStars pos = 
  "celestia/smaller-stars"
  |>image' 601 601
  |>move pos

stars : Coordinate -> Form
stars pos = 
  "celestia/stars-1"
  |>image' 601 601
  |>move pos

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm

sky : Coordinate -> Form
sky (x,y) =
  let 
    transparency = 
      let 
        x'   = x - 60000
        y'   = y - 60000
        dist = sqrt (x'^2 + y'^2) 
      in
      if dist > 10000 then 0
      else (10000 - dist) / 5000
  in
  "celestia/sky"
  |>image' 601 601
  |>alpha transparency
