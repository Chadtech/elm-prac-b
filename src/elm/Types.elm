module Types exposing (..)

import Time             exposing (..)
import Random           exposing (..)
import Keyboard.Extra   as Keyboard
import Debug exposing (log)

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg
  | CheckForCollisions Time
  | Pause

type Quadrant 
  = A
  | B
  | C
  | D

type alias Angle      = Float
type alias Coordinate = (Float, Float)
type alias Sector     = (Int, Int)
type alias Dimensions = (Int, Int)
type alias Time       = Float
type alias Things     = List Thing

--      |
--   A  |  B
--      |
--  ---------
--      |
--   C  |  D
--      |

type alias Model =
  { ship   : Ship
  , keys   : Keyboard.Model
  , things : Things
  , paused : Bool
  }

type alias World = 
  { things : List Thing }

type alias Thing =
  { local    : Coordinate
  , global   : Coordinate
  , velocity : Coordinate
  , angle    : (Float, Float)

  , sector     : Sector
  , dimensions : Dimensions

  , onCollision : Ship -> Ship

  , sprite : Sprite
  }

type alias Sprite =
  { dimensions : Dimensions
  , src : String
  }

type alias Thrusters =
  { leftFront  : Int
  , leftSide   : Int
  , leftBack   : Int
  , main       : Int
  , rightFront : Int
  , rightSide  : Int
  , rightBack  : Int
  , boost      : Bool
  }

type alias Ship =
  { angle       : (Float, Float)
  , local       : Coordinate
  , global      : Coordinate
  , velocity    : Coordinate

  , dir         : Float

  , sector      : Sector
  , quadrant    : Quadrant

  , dimensions  : Dimensions

  , fuel        : Float
  , oxygen      : Float
  , weight      : Float

  , thrusters   : Thrusters
  }
