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
    [ o2box (10000, 60000) (0, 150) 30
    , o2box (60000, 10000) (140, -10) 30
    , o2box (30000, 60000) (0, 290) 30
    , o2box (45000, 60000) (0, -400) 30

    , o2box (30000, 60000) (57, 250) -30
    , o2box (30000, 60000) (61, 250) 25
    , o2box (30000, 60000)(-44, 248) 55
    , o2box (30000, 60000) (50, 251) -87
    , o2box (30000, 60000) (33, 250)  -3
    , o2box (30000, 60000) (100, 250) 11
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

angleGen : Generator Float
angleGen = float -30 30

o2box : (Float, Float) -> (Float, Float) -> Float -> Thing
o2box (gx, gy) (vx, vy) va =
  let
    gx' = round gx
    gy' = round gy
  in
  { x = (toFloat (gx' % 600)) + gx - (toFloat gx')
  , y = (toFloat (gy' % 600)) + gy - (toFloat gy')
  , a = 0

  , vx = vx
  , vy = vy
  , va = va

  , gx = gx
  , gy = gy

  , sector = (gx' // 600, gy' // 600)

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
  , vy           = 150
  , va           = 0

  , sector       = (0, 0) 
  , quadrant     = C

  , gx           = 550
  , gy           = 550

  , dir          = 0

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }