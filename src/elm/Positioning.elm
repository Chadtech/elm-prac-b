module Positioning exposing (shipPosition)

import Types exposing (..)
import Debug exposing (log)

moduloPos : Float -> Float
moduloPos n =
  if n > 300 then moduloPos (n - 600)
  else n

moduloNeg : Float -> Float
moduloNeg n =
  if n < -300 then moduloNeg (n + 600)
  else n

modulo : Float -> Float
modulo = moduloPos >> moduloNeg

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

pos : Float -> Bool
pos n = n > 0

passedAxis : (Float, Float) -> Float
passedAxis (p, f) =
  if not ((p > 0) == (f > 0)) then 
    f - p
  else 
    0

shipPosition : Float -> Ship -> Ship
shipPosition dt s =
  let 
    y' = s.y + (dt * s.vy)
    x' = s.x + (dt * s.vx)
    a' = s.a + (dt * s.va)

    ym = modulo y'
    xm = modulo x'

    ye = log "P,F" (passedAxis (s.y, y'))

    --(sx, sy) = s.sector

    dyt = (round (y' - ym)) // 600 
    dxt = (round (x' - xm)) // 600
  in
    { s
    | x      = xm
    , y      = ym
    , a      = moduloAngle a'
    --, sector = (sx + dxt, sy + dyt)
    } 

