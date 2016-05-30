module Types exposing (..)

import Time             exposing (..)

type Msg 
  = Refresh Time

type alias World = 
  { frege : Ship }

type alias Ship =
  { x:            Float
  , y:            Float
  , a:            Float

  , vx:           Float
  , vy:           Float
  , va:           Float

  , fuel:         Float
  , oxygen:       Float
  , weight:       Float

  , thrusters: 
    { leftFront:  Int
    , leftSide:   Int
    , leftBack:   Int
    , main:       Int
    , rightFront: Int
    , rightSide:  Int
    , rightBack:  Int
    , boost:      Bool
    }
  }

frege : Ship
frege = 
  { x            = 0
  , y            = 0
  , a            = 0

  , vx           = -2.4275
  , vy           = 4.472
  , va           = -2

  , fuel         = 1410.1
  , oxygen       = 166
  , weight       = 852

  , thrusters    =
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