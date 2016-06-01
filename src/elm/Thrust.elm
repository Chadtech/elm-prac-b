module Thrust exposing (..)

import List exposing (foldr)
import Types exposing (..)
import Debug exposing (log)

setThrust : Ship -> Ship
setThrust s =
  let t = s.thrusters
  in
  { s
  | vy = s.vy + (thrustY (s.a, t))
  , vx = s.vx + (thrustX (s.a, t))
  , va = s.va + ((thrustA t))
 }

weakPower : Float
weakPower = 0.128

mainPower : Float
mainPower = weakPower * 7

rotatePower : Int -> Float
rotatePower i = 
  (toFloat i) * weakPower * 0.5

wp : Float -> Int -> Float
wp f i = weakPower * f * toFloat i

getThrust : Bool -> List Float -> Float
getThrust b l =
  (if b then 5 else 1) * (foldr (+) 0 l)

c : Float -> Float
c a = cos <| degrees a

s : Float -> Float
s a = sin <| degrees a

thrustY : (Float, Thrusters) -> Float
thrustY (a, t) =
  getThrust t.boost
  [  mainPower * (c a) * toFloat t.main
  ,  (wp (c a) t.leftBack)  
  , -(wp (c a) t.leftFront) 
  ,  (wp (c a) t.rightBack) 
  , -(wp (c a) t.rightFront)
  , -(wp (s a) t.leftSide)   
  ,  (wp (s a) t.rightSide)  
  ]

thrustX : (Float, Thrusters) -> Float
thrustX (a, t) =
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