module Types exposing (..)

import Time             exposing (..)
import Keyboard.Extra   as Keyboard

initModel : Model
initModel = 
  { world = world
  , ship  = frege thrusters
  , keys  = fst Keyboard.init
  }

world : World
world = 
  { stuff =
    [ { x      = -150
      , y      = -100
      , a      = 0

      , vx     = 1
      , vy     = 0
      , va     = 1

      , sprite = "stuff/oxygen-tank"

    }]
  }

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg

type alias Model =
  { world : World 
  , ship  : Ship
  , keys  : Keyboard.Model
  }

type alias Thing =
  { x           : Float
  , y           : Float
  , a           : Float

  , vx          : Float
  , vy          : Float
  , va          : Float

  , sprite      : String
  }

type alias World = 
  { stuff : List Thing }

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
  { x            = -150
  , y            = -150
  , a            = 20

  , vx           = 0
  , vy           = 0
  , va           = 0

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }