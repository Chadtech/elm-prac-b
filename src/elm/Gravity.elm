module Gravity exposing (shipGravity, thingGravity)

import Types            exposing (..)


shipGravity : Float -> Ship -> Ship
shipGravity dt s = 
  let
    dist  = sqrt ((s.gx - 60000)^2 + (s.gy - 60000)^2)
    angle = atan2 (s.gx - 60000) (s.gy - 60000)
    g     = (50000 / dist)^2
    vx'   = g * dt * (sin angle)
    vy'   = g * dt * (cos angle)
  in
  { s
  | vx = s.vx - vx'
  , vy = s.vy - vy'
  }

thingGravity : Float -> Thing -> Thing
thingGravity dt t = 
  let
    dist  = sqrt ((t.gx - 60000)^2 + (t.gy - 60000)^2)
    angle = atan2 (t.gx - 60000) (t.gy - 60000)
    g     = (50000 / dist)^2
    vx'   = g * dt * (sin angle)
    vy'   = g * dt * (cos angle)
  in
  { t
  | vx = t.vx - vx'
  , vy = t.vy - vy'
  }