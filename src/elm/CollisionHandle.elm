module CollisionHandle exposing (collisionsHandle)

import Collision        exposing (..)
import Types            exposing (..)
import List             exposing (map, concat, filter, length, foldr, append)
import Debug            exposing (log)


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
  in
  toPolygon
  (t.a + t.va)
  (t.gx - sgx + (t.vx * dt) - svx, t.gy - sgy + (t.vy * dt) - svy)
  ((dt * t.vx) - svx, (dt * t.vy) - svy)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

shipsPolygon : Ship -> List Pt
shipsPolygon s =
  let 
    (w', h') = s.dimensions 
    w = toFloat w'
    h = toFloat h'
  in
  rotatePoints (s.a + s.va)
  [ (w/2, h/2)
  , (w/2, -h/2)
  , (-w/2, -h/2)
  , (-w/2, h/2)
  ]

rotatePoint : Float -> (Float, Float) -> (Float, Float)
rotatePoint a' (r, a) = (r, a + a')

rotatePoints : Float -> List Pt -> List (Float, Float)
rotatePoints a' =
  map (toPolar >> rotatePoint a' >> fromPolar)

collisions : Float -> Ship -> Thing -> (Bool, Thing)
collisions dt s t = 
  let
    thingsPolygon' = 
      thingsPolygon
      dt
      (s.vx * dt, s.vy * dt)
      (s.gx, s.gy)
      t
  in
  (collision 10
    (thingsPolygon', polySupport)
    (shipsPolygon s, polySupport)
  , t)

collisionAction : Thing -> Ship -> Ship
collisionAction t s = t.onCollision s

appendIfNotCollided : (Bool, Thing) -> List Thing -> List Thing
appendIfNotCollided (b, t) things =
  if b then things
  else append things [t]

justThings : (Bool, Thing) -> Bool
justThings (b, t) = b

collisionsHandle : Float -> Model -> Model
collisionsHandle dt model =
  let
    collisionCheck = 
      map
        (collisions dt model.ship)
        model.things 

    collidedThings = 
      filter 
        justThings
        collisionCheck
  in
  if (length collidedThings) > 0 then 
    { model
    | ship = 
        foldr
          collisionAction
          model.ship
          (map (\t -> snd t) collidedThings)
    , things =
        foldr
          appendIfNotCollided
          []
          collisionCheck
    }
  else model










