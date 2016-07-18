module ShipPosition exposing (shipPosition)

import Types exposing (..)
import Debug exposing (log)


modulo : Float -> Float
modulo f =
  let 
    f' = round f 
    m = (toFloat (f' % 600)) + (f - (toFloat f'))
  in
  if m > 300 then m - 600 else m

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

axisCrosses : (Float, Float) -> Int
axisCrosses (p, f) =
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
    vy' = dt * s.vy
    vx' = dt * s.vx

    gym = modulo (s.gy + vy')
    gxm = modulo (s.gx + vx')

    (sx, sy) = s.sector
    
    dsy = 
      axisCrosses
      (s.y, s.y + vy')
    
    dsx = 
      axisCrosses
      (s.x, s.x + vx')
  in
  { s
  | x        = gxm
  , y        = gym
  , a        = moduloAngle (s.a + (dt * s.va))
  , sector   = (sx + dsx, sy + dsy)
  , quadrant = setQuadrant (gxm, gym)
  , gx       = s.gx + (dt * s.vx)
  , gy       = s.gy + (dt * s.vy)
  , dir      = atan2 s.vx s.vy
  } 

