module Types exposing (..)

import Time             exposing (..)
import Keyboard.Extra   as Keyboard


type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg

type Quadrant 
  = A
  | B
  | C
  | D

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
  , things : List Thing
  }

initModel : Model
initModel = 
  { ship   = frege thrusters
  , keys   = fst Keyboard.init
  , things = [ o2Box ]
  }

type alias World = 
  { things : List Thing }

type alias Thing =
  { x : Float
  , y : Float
  , a : Float

  , vx : Float
  , vy : Float
  , va : Float

  , sector   : (Int, Int)
  , quadrant : Quadrant

  , sprite : Sprite
  }

type alias Sprite =
  { w   : Int
  , h   : Int
  , src : String
  }

o2Box : Thing
o2Box =
  { x = 550
  , y = 575
  , a = 0

  , vx = 0
  , vy = 0
  , va = 0

  , sector   = (0, 0)
  , quadrant = C
  , sprite = 
    { w    = 20
    , h    = 20
    , src  = "stuff/oxygen-tank"
    }
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
  , quadrant    : Quadrant

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
  , quadrant     = C

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }