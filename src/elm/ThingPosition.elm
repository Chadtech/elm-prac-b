module ThingPosition exposing (thingPosition)

import Types exposing (..)
import Debug exposing (log)

modulo : Float -> Float
modulo f =
  let f' = round f in
  (toFloat (f' % 600)) + (f - (toFloat f'))

moduloTop : Float -> Float
moduloTop n = 
  if n > 600 then moduloTop (n - 600)
  else n

moduloBottom : Float -> Float
moduloBottom n =
  if 0 > n then moduloBottom (n + 600)
  else n

--modulo : Float -> Float
--modulo = moduloTop >> moduloBottom

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

getSector : Float -> Int
getSector f =
  floor (f / 600)

thingPosition : Float -> Thing -> Thing
thingPosition dt t =
  let
    y' = t.gy + (dt * t.vy)
    x' = t.gx + (dt * t.vx)
    a' = t.a + (dt * t.va)

    ym = modulo y'
    xm = modulo x'

    --ya = log "not g and g" (modulo (t.y + (dt * t.vy)), ym)

    (tx, ty) = t.sector
    dty = (round (y' - ym)) // 600
    dtx = (round (x' - xm)) // 600
  in
  { t
  | x = xm
  , y = ym
  , a = moduloAngle a'
  , sector = (getSector x', getSector y')
  , gx     = t.gx + (dt * t.vx)
  , gy     = t.gy + (dt * t.vy)
  }