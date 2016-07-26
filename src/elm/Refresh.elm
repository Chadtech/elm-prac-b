module Refresh exposing (refresh)

import SetWeight        exposing (setWeight)
import Types            exposing (..)
import Gravity          exposing (shipGravity, thingGravity)
import Thrust           exposing (setThrust)
import List             exposing (map)
import Consumption      exposing (consumption)
import ShipPosition     exposing (shipPosition)
import ThingPosition    exposing (thingPosition)


refresh : Time -> Model -> Model
refresh dt m =
  let
    (isDead, deathMsg) =
      checkIfDead m.ship
  in
  { m 
  | ship = refreshShip dt m.ship
  , things = 
      m.things
      |>map (refreshThing dt)
  , died     = isDead || m.died
  , deathMsg = deathMsg
  }

refreshShip : Time -> (Ship -> Ship)
refreshShip dt =
  consumption dt
  >>setWeight
  >>setThrust
  >>shipGravity dt
  >>shipPosition dt

checkIfDead : Ship -> (Bool, String)
checkIfDead s =
  let
    (x,y) = s.global
    x' = x - 60000
    y' = y - 60000
    noMoreAir = s.oxygen < 1
    tooCloseToPlanet = 
      (sqrt (x'^2 + y'^2)) < 5000 

    deathMsg =
      if noMoreAir then "You ran out of air"
      else
        if tooCloseToPlanet then 
          "You burnt up in the atmosphere"
        else ""
  in 
    (noMoreAir || tooCloseToPlanet, deathMsg)

refreshThing : Time -> (Thing -> Thing)
refreshThing dt =
  thingPosition dt >> thingGravity dt