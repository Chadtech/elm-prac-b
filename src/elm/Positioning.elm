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

passedAxis : (Float, Float) -> Int
passedAxis (p, f) =
  if (p > 0) /= (f > 0) then 
    ((f // 600) + 1) * (abs f // f)
  else 0

setQuadrant : (Float, Float) -> Quadrant
setQuadrant (x, y) =
  if x > 0 then
    if y > 0 then B else D
  else
    if y > 0 then A else C

shipPosition : Float -> Ship -> Ship
shipPosition dt s =
  let 
    y' = s.y + (dt * s.vy)
    x' = s.x + (dt * s.vx)
    a' = s.a + (dt * s.va)

    ym = modulo y'
    xm = modulo x'

    (sx, sy) = s.sector
    dsy      = passedAxis (s.y, y')
    dsx      = passedAxis (s.x, x')
  in
    { s
    | x        = xm
    , y        = ym
    , a        = moduloAngle a'
    , sector   = (sx + dsx, sy + dsy)
    , quadrant = setQuadrant (xm, ym)
    } 

