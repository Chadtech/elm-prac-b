module Types exposing (..)

import Time             exposing (..)
import Random           exposing (..)
import Keyboard.Extra   as Keyboard
import Debug exposing (log)

type Msg 
  = Refresh Time
  | HandleKeys Keyboard.Msg
  | CheckForCollisions Time

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
    [ o2box (45000, 60000) (0, -400) 30 ]
    --[ o2box (525, 550) (0, 150) 30
    --, o2box (10000, 60000) (0, 150) 30
    --, o2box (60000, 10000) (140, -10) 30
    --, o2box (30000, 60000) (0, 290) 30
    --, o2box (45000, 60000) (0, -400) 30
    ----, o2box (45050, 60000) (0, -400) 30

    --, o2box (30000, 60000) (57, 250) -30
    --, o2box (30000, 60000) (61, 250) 25
    --, o2box (30000, 60000)(-44, 248) 55
    --, o2box (30000, 60000) (50, 251) -87
    --, o2box (30000, 60000) (33, 250)  -3
    --, o2box (30000, 60000) (100, 250) 11
    --]
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

  , dimensions : (Int, Int)

  , onCollision : Ship -> Ship

  , sprite : Sprite
  }

type alias Sprite =
  { w   : Int
  , h   : Int
  , src : String
  }

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

  , dimensions = (20, 20)

  , onCollision = giveOxygen

  , sprite = 
    { w    = 20
    , h    = 20
    , src  = "stuff/oxygen-tank"
    }
  }

giveOxygen : Ship -> Ship
giveOxygen s =
  { s | oxygen = s.oxygen + 500 }


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

  --, local       : (Float, Float)
  --, global      : (Float, Float)

  , vx          : Float
  , vy          : Float
  , va          : Float

  -- the g is for 'global'.
  , gx          : Float
  , gy          : Float

  , dir         : Float

  , sector      : (Int, Int)
  , quadrant    : Quadrant

  , dimensions : (Int, Int)

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

--modulo : Float -> Float
--modulo f =
--  let 
--    f' = round f 
--    m = (toFloat (f' % 600)) + (f - (toFloat f'))
--  in
--  if m > 300 then m - 600 else m

setSector : Float -> Int
setSector f =
  (floor (f / 600))

frege : Thrusters -> Ship
frege t = 
  let
    --gx = 45100
    gx = 44900
    gy = 60000

    x =
      if gx > 600 then gx - 600
      else gx

    y =
      if gy > 600 then gy - 600
      else gy

  in
  { x            = x
  , y            = y
  , a            = 0

  --, local        = (x, y)
  --, global       = (gx, gy)

  , vx           = 0
  , vy           = -400
  , va           = 0

  , sector       = (setSector gx, setSector gy)
  , quadrant     = C

  , gx           = gx
  , gy           = gy

  , dir          = 0

  , dimensions   = (34, 29)

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    = t

  }
  --{ x            = -50
  --, y            = -50
  --, a            = 0

  --, vx           = 0
  --, vy           = 150
  --, va           = 0

  --, sector       = (0, 0) 
  --, quadrant     = C

  --, gx           = 550
  --, gy           = 550

  --, dir          = 0

  --, fuel         = 1410.1
  --, oxygen       = 166
  --, weight       = 852

  --, thrusters    = t

  --}