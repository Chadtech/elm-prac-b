module ThingPosition exposing (thingPosition)

import Types exposing (..)
import Debug exposing (log)

modulo : Float -> Float
modulo f =
  let f' = round f in
  (toFloat (f' % 600)) + (f - (toFloat f'))

moduloClockwise : Angle -> Angle
moduloClockwise a =
  if a > 180 then
    moduloClockwise (a - 360)
  else a

moduloCClockwise : Angle -> Angle
moduloCClockwise a =
  if a < -180 then
    moduloCClockwise (a + 360)
  else a

moduloAngle : Angle -> Angle
moduloAngle =
  moduloClockwise >> moduloCClockwise

getSector : Float -> Int
getSector f = floor (f / 600)

thingPosition : Time -> Thing -> Thing
thingPosition dt t =
  let
    y' = t.gy + (dt * t.vy)
    x' = t.gx + (dt * t.vx)
    a' = t.a + (dt * t.va)

    ym = modulo y'
    xm = modulo x'

  in
  { t
  | x = xm
  , y = ym
  , a = moduloAngle a'
  , sector = (getSector x', getSector y')
  , gx     = t.gx + (dt * t.vx)
  , gy     = t.gy + (dt * t.vy)
  }