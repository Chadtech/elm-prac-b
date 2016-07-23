module Init exposing (..)

import Types exposing (..)
import Keyboard.Extra   as Keyboard


initModel : Model
initModel = 
  { ship   = frege
  , keys   = fst Keyboard.init
  , things = 
    --[ o2box (45000, 60000) (0, -400) 30 ]
    [ fuelTank (10000, 60000) (0, -150) 30
    , o2box (10000, 60000) (1, -148) 30
    , fuelTank (60000, 10000) (140, -10) 30
    , o2box (30000, 60000) (0, 290) 30
    , fuelTank (44800, 60000) (0, -400) 30
    , o2box (45050, 60000) (0, -400) 30

    , fuelTank (30000, 55000) (50, -250) -60
    , o2box (30000, 55000) (57, -250) -30
    , o2box (30000, 60000) (57, -250) -30
    , fuelTank (30000, 60000) (61, 250) 25
    , o2box (30000, 60000) (-44, -248) 55
    , fuelTank (30000, 60000) (50, 251) -87
    , o2box (30000, 60000) (33, 250)  -3
    , fuelTank (30000, 60000) (100, 250) 11
    ]
  , paused = False
  }

o2box : (Float, Float) -> (Float, Float) -> Float -> Thing
o2box (gx, gy) (vx, vy) va =
  let
    sx = (round gx) // 600
    sy = (round gy) // 600
    x  = (toFloat (sx % 600)) + gx - (toFloat sx)
    y  = (toFloat (sy % 600)) + gy - (toFloat sy)
    dimensions = (20, 20)
  in
  { angle    = (0, va)
  , velocity = (vx, vy)
  , local    = (x,y)
  , global   = (gx, gy)
  , sector   = (sx, sy)

  , dimensions = dimensions

  , onCollision = giveOxygen

  , sprite = 
    { dimensions = dimensions
    , src  = "stuff/oxygen-tank"
    }
  }

fuelTank : (Float, Float) -> (Float, Float) -> Float -> Thing
fuelTank (gx, gy) (vx, vy) va =
  let
    sx = (round gx) // 600
    sy = (round gy) // 600
    x  = (toFloat (sx % 600)) + gx - (toFloat sx)
    y  = (toFloat (sy % 600)) + gy - (toFloat sy)
    dimensions = (20, 30)
  in
  { angle    = (0, va)
  , velocity = (vx, vy)
  , local    = (x,y)
  , global   = (gx, gy)
  , sector   = (sx, sy)

  , dimensions = dimensions

  , onCollision = giveFuel

  , sprite = 
    { dimensions = dimensions
    , src  = "stuff/fuel-tank"
    }
  }

giveFuel : Ship -> Ship
giveFuel s =
  { s | fuel = s.fuel + 1000 }

giveOxygen : Ship -> Ship
giveOxygen s =
  { s | oxygen = s.oxygen + 150 }

setSector : Float -> Int
setSector f = (floor (f / 600))

frege : Ship
frege = 
  let
    gx = 44900
    gy = 60000

    x =
      if gx > 600 then gx - 600
      else gx

    y =
      if gy > 600 then gy - 600
      else gy

  in
  { angle      = (0, 0)
  , local      = (x, y)
  , global     = (gx, gy)
  , velocity   = (0, -400)

  , sector     = (setSector gx, setSector gy)
  , quadrant   = C

  , dir        = 0

  , dimensions = (34, 29)

  , fuel       = 1005.1
  , oxygen     = 63
  , weight     = 852

  , thrusters  =
    { leftFront  = 0
    , leftSide   = 0
    , leftBack   = 0
    , main       = 0
    , rightFront = 0
    , rightSide  = 0
    , rightBack  = 0
    , boost      = False
    }
  }