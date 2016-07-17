module Types exposing (..)

import Time             exposing (..)
import Random           exposing (..)
import Keyboard.Extra   as Keyboard
import Debug exposing (log)

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
  , things = 
    [ o2box (550, 575) (0, 150) 
    , o2box (525, 557) (5, 150)
    ]
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

  -- the g is for 'global'.
  , gx     : Float
  , gy     : Float

  , sector : (Int, Int)

  , sprite : Sprite
  }

type alias Sprite =
  { w   : Int
  , h   : Int
  , src : String
  }

--o2Box : Thing
--o2Box =
--  { x = 550
--  , y = 575
--  , a = 0

--  , vx = 0
--  , vy = 150
--  , va = 1

--  , gx = 0
--  , gy = 0

--  , sector   = (0, 0)

--  , sprite = 
--    { w    = 20
--    , h    = 20
--    , src  = "stuff/oxygen-tank"
--    }
--  }

o2box : (Float, Float) -> (Float, Float) -> Thing
o2box (gx, gy) (vx, vy) =
  let
    x = (toFloat ((round gx) % 600)) + (gx - (toFloat (round gx)))
    y = (toFloat ((round gy) % 600)) + (gy - (toFloat (round gy)))

    sx = (round gx) // 600
    sy = (round gy) // 600

    ye = log "cors and sectors" ((x,y),(sx,sy))
  in
  { x = x
  , y = y
  , a = 0

  , vx = vx
  , vy = vy
  , va = 1

  , gx = 0
  , gy = 0

  , sector   = (0, 0)

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

  -- the g is for 'global'.
  , gx          : Float
  , gy          : Float

  , dir         : Float

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

  , gx           = 0
  , gy           = 0

  , dir          = 0

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }