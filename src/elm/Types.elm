module Types exposing (..)

import Time             exposing (..)
import Keyboard.Extra   as Keyboard
import List             exposing (map, take, drop, head, tail, append, repeat)

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg

type alias Model =
  { world : World 
  , ship  : Ship
  , keys  : Keyboard.Model
  }

initModel : Model
initModel = 
  { world = world
  , ship  = frege thrusters
  , keys  = fst Keyboard.init
  }

world : World
world = 
  { sectors = 
    [ [ "r", "g", "r", "g" ]
    , [ "r", "r", "g", "g" ]
    , [ "r", "g", "r", "r" ]
    , [ "g", "r", "g", "g" ]
    ]
  , content =
    [ { x      = 50
      , y      = 50
      , a      = 0

      , vx     = 0
      , vy     = 0
      , va     = -4

      , sector = (10, 10)
      , sprite = oxygenSprite
      }
    , { x      = -150
      , y      = -10
      , a      = 0

      , vx     = 2.53
      , vy     = -3.64
      , va     = -10

      , sector = (10, 10)
      , sprite = oxygenSprite
      }
    , { x      = 150
      , y      = -10
      , a      = 0

      , vx     = 20.53
      , vy     = 5
      , va     = 1

      , sector = (10, 10)
      , sprite = oxygenSprite
      }
    , { x      = -150
      , y      = -10
      , a      = 0

      , vx     = 19.1
      , vy     = 7.04
      , va     = 20

      , sector = (10, 10)
      , sprite = oxygenSprite
      }
    ]
  }

oxygenSprite =
  { src = "stuff/oxygen-tank"
  , w   = 20
  , h   = 20
  }

type alias Sprite =
  { src : String
  , w   : Int
  , h   : Int
  }

type alias Thing =
  { x           : Float
  , y           : Float
  , a           : Float

  , sector      : (Int, Int)

  , vx          : Float
  , vy          : Float
  , va          : Float

  , sprite      : Sprite
  }

type alias World = 
  { sectors: List (List String) 
  , content: List Thing
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

  , sector      : (Int, Int)

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

  , sector       = (0, 0) 

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }