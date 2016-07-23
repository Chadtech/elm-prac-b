module Thrust exposing (..)

import List exposing (sum)
import Types exposing (..)
import Debug exposing (log)

setThrust : Ship -> Ship
setThrust s =
  let 
    t = s.thrusters 
    (a, va)  = s.angle
    (vx, vy) = s.velocity
    weightFactor = s.weight / 526

    dvx = (thrustX a t) / weightFactor
    dvy = (thrustY a t) / weightFactor
    dva = (thrustA t) / weightFactor

  in
  if s.fuel > 0 then
  { s
  | velocity = (vx + dvx, vy + dvy)
  , angle    = (a, va + dva)
  }
  else s

weakPower : Float
weakPower = 0.128

mainPower : Float
mainPower = weakPower * 7

rotatePower : Int -> Float
rotatePower i = 
  (toFloat i) * weakPower * 0.3

wp : Float -> Int -> Float
wp f i = weakPower * f * toFloat i

getThrust : Bool -> List Float -> Float
getThrust b list =
  (if b then 5 else 1) * (sum list)

c : Float -> Float
c = cos << degrees

s : Float -> Float
s = sin << degrees

thrustY : Angle -> Thrusters -> Float
thrustY a t =
  getThrust t.boost
  [  mainPower * (c a) * toFloat t.main
  ,  (wp (c a) t.leftBack)  
  , -(wp (c a) t.leftFront) 
  ,  (wp (c a) t.rightBack) 
  , -(wp (c a) t.rightFront)
  , -(wp (s a) t.leftSide)   
  ,  (wp (s a) t.rightSide)  
  ]

thrustX : Angle -> Thrusters -> Float
thrustX a t =
  getThrust t.boost
  [ -mainPower * (s a) * toFloat t.main
  , -(wp (s a) t.leftBack)
  ,  (wp (s a) t.leftFront)
  , -(wp (s a) t.rightBack)
  ,  (wp (s a) t.rightFront)
  , -(wp (c a) t.leftSide)
  ,  (wp (c a) t.rightSide)
  ]

thrustA : Thrusters -> Float
thrustA t =
  getThrust t.boost
  [ -(rotatePower t.leftBack)
  ,  (rotatePower t.leftFront)
  ,  (rotatePower t.rightBack)
  , -(rotatePower t.rightFront)
  ]