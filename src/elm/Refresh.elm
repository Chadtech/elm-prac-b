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
  { m 
  | ship = refreshShip dt m.ship
  , things = 
      m.things
      |>map (refreshThing dt)
  }

refreshShip : Time -> (Ship -> Ship)
refreshShip dt =
  consumption dt
  >>setWeight
  >>setThrust
  >>shipGravity dt
  >>shipPosition dt

refreshThing : Time -> (Thing -> Thing)
refreshThing dt =
  thingPosition dt >> thingGravity dt