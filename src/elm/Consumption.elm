module Consumption exposing (consumption)

import List  exposing (sum, product)
import Types exposing (..)

consumption : Float -> (Ship -> Ship)
consumption dt = 
  consumeAir dt >> consumeFuel dt

consumeAir : Float -> Ship -> Ship
consumeAir dt s =
  if s.oxygen > 0 then
    { s | oxygen = s.oxygen - (dt / 100) }
  else 
    { s | oxygen = 0 }

consumeFuel : Float -> Ship -> Ship
consumeFuel dt s =
  let
    t = s.thrusters
    rate = 
      if t.boost then 7
      else 1
    consumption =
      product 
      [ 0.1
      , rate
      , dt
      , toFloat
        <|sum 
          [ t.leftFront
          , t.leftSide
          , t.leftBack
          , t.rightFront
          , t.rightSide
          , t.rightBack
          , t.main * 5
          ]
      ]
  in
  if s.fuel > 0 then
    { s | fuel = s.fuel - consumption }
   else
    { s | fuel = 0 }
