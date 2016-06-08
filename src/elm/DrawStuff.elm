module DrawStuff exposing (populate)

import Collage          exposing (..)
import Element          exposing (..)
import Types            exposing (..)
import List             exposing (filter, map)
import Debug            exposing (log)
import Source           exposing (src)

layerer : List Form -> Element
layerer = collage 1200 1200

pos : (Int, Int) -> Thing -> (Float, Float)
pos (x,y) t =
  let 
    (x',y') = t.sector
    tf = toFloat
  in 
    ((((tf x) - (tf x')) * 600) + t.x 
    ,(((tf y) - (tf y')) * 600) + t.y )

populate : (Ship, World) -> Form ->Form
populate (ship, world) f =
  let
    s = ship.sector
    stuff = filter (near s) world.content
  in
    layerer
    [ toForm
      <|layerer
      <|map (drawThing s) 
      <|stuff
    , f
    ]
    |>toForm

near : (Int, Int) -> Thing -> Bool
near (x,y) t =
  let
    (x',y') = t.sector

    x'' = abs (x - x') <= 2
    y'' = abs (y - y') <= 2
  in 
    x'' && y''

drawThing : (Int, Int) -> Thing -> Form
drawThing p t =
  let s = t.sprite
  in 
    image s.w s.h (src s.src)
    |>toForm
    |>move (pos p t)
    |>rotate (degrees t.a)


