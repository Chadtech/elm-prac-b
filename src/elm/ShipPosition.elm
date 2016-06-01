module ShipPosition exposing (position)

import Types exposing (..)
import Debug exposing (log)

moduloPos : Float -> Float
moduloPos n =
  if n > 300 then 
    moduloPos (n - 600)
  else n

moduloNeg : Float -> Float
moduloNeg n =
  if n < -300 then 
    moduloNeg (n + 600)
  else n

modulo : Float -> Float
modulo =
  moduloPos >> moduloNeg

moduloClockwise : Float -> Float
moduloClockwise a =
  if a > 180 then
    moduloClockwise (a - 360)
  else a

moduloCClockwise : Float -> Float
moduloCClockwise a =
  if a < -180 then
    moduloCClockwise (a + 360)
  else a

moduloAngle : Float -> Float
moduloAngle =
  moduloClockwise >> moduloCClockwise

position : Float -> Ship -> Ship
position dt s =
  let 
    y' = s.y + (dt * s.vy)
    x' = s.x + (dt * s.vx)
    a' = s.a + (dt * s.va)

    ym = modulo y'
    xm = modulo x'
  in
    { s
    | x = xm
    , y = ym
    , a = moduloAngle a'
    } 
