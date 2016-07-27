module CollisionHandle exposing (collisionsHandle)

import Collision exposing (..)
import Types     exposing (..)
import List      exposing (map, concat, filter, isEmpty, foldr, append)
import Debug     exposing (log)


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
      (List.maximum decorated)
  in
    p

smear : Pt -> Pt -> List Pt
smear (x', y') (x, y) = 
  [ (x, y), (x + x', y + y') ]

place : Pt -> Pt -> Pt
place (gx, gy) (x, y) =
  (x + gx, y + gy)

travel : Float -> Pt -> (Pt -> List Pt)
travel a dest =
  toPolar
  >>rotatePoint a
  >>fromPolar
  >>smear dest

toPolygon : Float -> Pt -> Pt -> List Pt -> List Pt
toPolygon angle center destination points =
  points
  |>map (travel angle destination) 
  |>concat
  |>map (place center)

thingsPolygon : Float -> Pt -> Pt -> Thing -> List Pt
thingsPolygon dt (svx, svy) (sgx, sgy) t =
  let 
    (w', h') = t.dimensions 
    w = toFloat w'
    h = toFloat h'
    (gx, gy) = t.global
    (a, va) = t.angle
    (vx, vy) = t.velocity
    vx' = dt * vx
    vy' = dt * vy
  in
  toPolygon
  (a + va)
  (gx - sgx + vx' - svx, gy - sgy + vy' - svy)
  (vx' - svx, vy' - svy)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

shipsPolygon : Ship -> List Pt
shipsPolygon {angle, dimensions} =
  let 
    (w', h') = dimensions 
    w = toFloat w'
    h = toFloat h'
    (a, va) = angle
  in
  rotatePoints (a + va)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

rotatePoint : Angle -> (Float, Angle) -> (Float, Angle)
rotatePoint a' (r, a) = (r, a + a')

rotatePoints : Angle -> List Pt -> List Coordinate
rotatePoints a' =
  map (toPolar >> rotatePoint a' >> fromPolar)

collisions : Float -> Ship -> Thing -> (Bool, Thing)
collisions dt s t = 
  let
    (svx, svy) = s.velocity

    thingsPolygon' = 
      thingsPolygon
      dt
      (svx * dt, svy * dt)
      s.global
      t
  in
  (collision 10
    (thingsPolygon', polySupport)
    (shipsPolygon s, polySupport)
  , t)

collisionAction : Thing -> Ship -> Ship
collisionAction t s = t.onCollision s

appendIfNotCollided : (Bool, Thing) -> Things -> Things
appendIfNotCollided (b, t) things =
  if b then things
  else append things [t]

justThings : (Bool, Thing) -> Bool
justThings (b, t) = b

collisionsHandle : Time -> Model -> Model
collisionsHandle dt m =
  let
    {ship, things} = m
    collisionCheck = 
      map (collisions dt ship) things 

    collidedThings = 
      filter justThings collisionCheck
  in
  if isEmpty collidedThings then 
    { m
    | ship = 
        foldr
          collisionAction
          ship
          (map snd collidedThings)
    , things =
        foldr
          appendIfNotCollided
          []
          collisionCheck
    }
  else m










