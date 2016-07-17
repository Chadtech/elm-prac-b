import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Time             exposing (..)
import Debug            exposing (log)
import AnimationFrame   exposing (..)
import ShipPosition     exposing (shipPosition)
import ThingPosition    exposing (thingPosition)
import Keyboard.Extra   as Keyboard
import ThrusterState    exposing (setThrusters)
import Thrust           exposing (setThrust)
import List             exposing (map)

main =
  App.program
  { init          = (initModel, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Sub.map HandleKeys Keyboard.subscriptions
    , diffs Refresh
    ]

refresh : Model -> Float -> Model
refresh m dt =
  { m 
  | ship = 
      m.ship
      --|>gravity dt
      |>shipPosition dt
      |>setThrust
  , things = map (thingPosition dt) m.things
  }

gravity : Float -> Ship -> Ship
gravity dt s = 
  let
    dist = sqrt ((s.gx - 60000)^2 + (s.gy - 60000)^2)
    dist' = 100000/dist
    angle = atan2 (s.gx - 60000) (s.gy - 60000)

    ass = log "angle" (angle/pi)
    vx' = (dt * (sin (angle)))
    vy' = (dt * (cos (angle)))

    ya = log "vx vy" (vx', vy')

    --wa = log "angle" (angle / pi)
    --ye = log "x and y" ((dt * dist' * (sin angle)) + s.vx, (dt * dist' * (cos angle)) + s.vy)
  in
  --s
  { s
  | vx = s.vx - vx'
  , vy = s.vy - vy'
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg m =
  case msg of 

    Refresh dt ->
      (refresh m (dt / 120), Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys', kCmd) = 
          Keyboard.update keyMsg m.keys
        ship = m.ship
      in
        (,)
          { m 
          | keys = keys'
          , ship = 
            { ship 
            | thrusters = setThrusters keys' 
            }
          } 
          (Cmd.map HandleKeys kCmd)

