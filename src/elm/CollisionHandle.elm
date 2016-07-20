module CollisionHandle exposing (collisionCheck)

import Collision        exposing (..)
import Types            exposing (..)
import List             exposing (map, concat)


dot : Pt -> Pt -> Float
dot (x1,y1) (x2,y2) = (x1*x2) + (y1*y2)

polySupport : List Pt -> Pt -> Pt
polySupport list d =
  let
    dotList = List.map (dot d) list
    decorated = List.map2 (,) dotList list
    (m, p) = 
      Maybe.withDefault
      (0,(0,0))
      (List.maximum decorated)-- maximum now returns a Maybe b
  in
    p

smear : Pt -> Pt -> List Pt
smear (x', y') (x, y) = 
  [ (x, y), (x + x', y + y') ]

place : Pt -> Pt -> Pt
place (gx, gy) (x, y) =
  (x + gx, y + gy)

rotatePoint : Float -> (Float, Float) -> (Float, Float)
rotatePoint a' (r, a) = (r, a + a')

travel : Float -> Pt -> (Pt -> List Pt)
travel a dest =
  toPolar
  >>rotatePoint a
  >>fromPolar
  >>smear dest

travel' : Float -> Pt -> (Pt -> Pt)
travel' a dest =
  toPolar
  >>rotatePoint a
  >>fromPolar

toPolygon : Float -> Pt -> Pt -> List Pt -> List Pt
toPolygon angle center destination points =
  points
  |>map (travel angle destination) 
  |>concat
  |>map (place center)

toPolygon' : Float -> Pt -> Pt -> List Pt -> List Pt
toPolygon' angle center destination points =
  points
  |>map (travel' angle destination) 
  |>map (place center)

thingsTravel : Thing -> List Pt
thingsTravel t =
  let 
    (w', h') = t.dimensions 
    w = toFloat w'
    h = toFloat h'
  in
  toPolygon'
  t.a
  (t.gx, t.gy)
  (t.vx, t.vy)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

shipsTravel : Ship -> List Pt
shipsTravel s =
  let 
    (w', h') = s.dimensions 
    w = toFloat w'
    h = toFloat h'
  in
  toPolygon'
  s.a
  (s.gx, s.gy)
  (s.vx, s.vy)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]


collisionCheck : Ship -> Thing -> Bool
collisionCheck s t = 
  collision 10
  ((thingsTravel t), polySupport)
  ((shipsTravel s), polySupport)

    --ya = 
    --  log "collision" 
    --  <|collision 10
    --    ([(0,0),(4,0),(2,1)], polySupport)
    --    ([(0,4),(4,4),(2,3)], polySupport)