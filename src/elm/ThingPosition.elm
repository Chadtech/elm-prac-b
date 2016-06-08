module ThingPosition exposing (thingPosition)

import Types exposing (..)

moduloPos : Float -> Float
moduloPos n =
  if n > 600 then moduloPos (n - 600)
  else n

moduloNeg : Float -> Float
moduloNeg n =
  if n < 0 then moduloNeg (n + 600)
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

thingPosition : Float -> Thing -> Thing
thingPosition dt t =
  let 
    y' = t.y + (dt * t.vy)
    x' = t.x + (dt * t.vx)
    a' = t.a + (dt * t.va)

    ym = modulo y'
    xm = modulo x'

    (tx, ty) = t.sector

    dyt = (round (y' - ym)) // 600 
    dxt = (round (x' - xm)) // 600
  in
    { t
    | x = xm
    , y = ym
    , a = moduloAngle a'
    , sector = (tx + dxt, ty + dyt)
    } 