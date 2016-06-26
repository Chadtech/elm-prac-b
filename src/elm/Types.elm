module Types exposing (..)

import Time             exposing (..)
import Keyboard.Extra   as Keyboard
import List             exposing (map, take, drop, head, tail, append, repeat)

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg

type alias Model =
  { ship  : Ship
  , keys  : Keyboard.Model
  }

initModel : Model
initModel = 
  { ship  = frege thrusters
  , keys  = fst Keyboard.init
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
  { x           : Float
  , y           : Float
  , a           : Float

  , vx          : Float
  , vy          : Float
  , va          : Float

  --, sector      : (Int, Int)

  , fuel        : Float
  , oxygen      : Float
  , weight      : Float

  , thrusters   : Thrusters
  }

thrusters : Thrusters
thrusters = 
  { leftFront  = 0
  , leftSide   = 0
  , leftBack   = 0
  , main       = 0
  , rightFront = 0
  , rightSide  = 0
  , rightBack  = 0
  , boost      = False
  }

frege : Thrusters -> Ship
frege t = 
  { x            = -50
  , y            = -50
  , a            = 0

  , vx           = 0
  , vy           = 0
  , va           = 0

  --, sector       = (0, 0) 

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }