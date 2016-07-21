module ThrusterState exposing (setThrusters)

import Keyboard.Extra exposing (isPressed)
import Keyboard.Extra as K
import Types exposing (Ship, Model, Thrusters)
import Debug exposing (log)

set : K.Model -> K.Key -> Int
set m k = 
  if isPressed k m then 1 
  else 0

setThrusters : K.Model -> Thrusters
setThrusters keys =
  let set' = set keys in
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
