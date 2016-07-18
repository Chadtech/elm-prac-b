module Gravity exposing (shipGravity, thingGravity)

import Types            exposing (..)

shipGravity : Float -> Ship -> Ship
shipGravity dt s =
  let 
    (gvx, gvy) =
      gravity dt (s.gx, s.gy)
  in
  { s
  | vx = s.vx - gvx
  , vy = s.vy - gvy
  }

thingGravity : Float -> Thing -> Thing
thingGravity dt t =
  let 
    (gvx, gvy) = 
      gravity dt (t.gx, t.gy) 
  in
  { t
  | vx = t.vx - gvx
  , vy = t.vy - gvy
  }

gravity : Float -> (Float, Float) -> (Float, Float)
gravity dt (x,y) =
  let
    dist  = sqrt ((x - 60000)^2 + (y - 60000)^2)
    angle = atan2 (x - 60000) (y - 60000)
    g     = dt * (50000 / dist)^2
  in (g * (sin angle), g * (cos angle))