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
import Gravity          exposing (shipGravity, thingGravity)
import CollisionHandle  exposing (collisionsHandle)

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
    , diffs CheckForCollisions
    ]


refresh : Model -> Float -> Model
refresh m dt =
  --let
  --  ya =
  --    log "YA" <|
  --    List.filter (collisionCheck m.ship) m.things
  --in
  { m 
  | ship = 
      m.ship
      |>shipGravity dt
      |>shipPosition dt
      |>setThrust
  , things = 
      m.things
      |>map (refreshThing dt)
  }

refreshThing : Float -> (Thing -> Thing)
refreshThing dt =
  thingPosition dt >> thingGravity dt

update : Msg -> Model -> (Model, Cmd Msg)
update msg m =
  case msg of 

    CheckForCollisions dt ->
      (collisionsHandle (dt / 120) m, Cmd.none)

    Refresh dt ->
      (refresh m (dt / 120), Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg m.keys
      in
        (handleKeys m keys, Cmd.map HandleKeys kCmd)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys m keys =
  let s = m.ship in
  { m
  | keys = keys
  , ship = 
    { s 
    | thrusters = setThrusters keys
    }
  }







