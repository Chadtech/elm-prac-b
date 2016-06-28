module ThingPosition exposing (thingPosition)

import Types exposing (..)
import Debug exposing (log)


moduloTop : Float -> Float
moduloTop n = 
  if n > 600 then moduloTop (n - 600)
  else n

moduloBottom : Float -> Float
moduloBottom n =
  if 0 > n then moduloBottom (n + 600)
  else n

modulo : Float -> Float
modulo = moduloTop >> moduloBottom

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
    dty = (round (y' - ym)) // 600
    dtx = (round (x' - xm)) // 600

    --ye = log "Ys" (y', ym)

  in
  { t
  | x = xm
  , y = ym
  , a = moduloAngle a'
  , sector = (tx + dtx, ty + dty)
  }