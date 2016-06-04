module ThrusterState exposing (setThrusters)

import Keyboard.Extra exposing (isPressed)
import Keyboard.Extra as K
import Types exposing (Ship, Model, Thrusters)
import Debug exposing (log)

set : K.Key -> K.Model -> Int
set k m = 
  (\b -> if b then 1 else 0)
  <|isPressed k m

setThrusters : K.Model -> Thrusters
setThrusters keys =
  let set' = \k -> set k keys
  in
  { leftFront  = set' K.CharC
  , leftSide   = set' K.CharS
  , leftBack   = set' K.CharE
  , main       = set' K.Space
  , rightFront = set' K.CharN
  , rightSide  = set' K.CharK
  , rightBack  = set' K.CharU
  , boost = 
      isPressed K.Shift keys
  }
