import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Time             exposing (..)
import Debug            exposing (log)
import AnimationFrame   exposing (..)
import Positioning      exposing (shipPosition)
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
  let world = m.world
  in
  { m 
  | ship = 
    m.ship
    |>shipPosition dt
    |>setThrust
  , world = 
    { world 
      | content = 
        (map (thingPosition dt) world.content)
    }
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
        t = setThrusters keys'
      in
        (,)
          { m 
          | keys = keys'
          , ship = 
            { ship | thrusters = t }
          } 
          (Cmd.map HandleKeys kCmd)

