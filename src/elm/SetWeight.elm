module SetWeight exposing (setWeight)

import Types exposing (Ship)

setWeight : Ship -> Ship
setWeight s =
  { s
  | weight = (s.fuel / 1.7) + (s.oxygen * 3) + 263
  }