import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Init             exposing (initModel)
import Debug            exposing (log)
import AnimationFrame   exposing (..)
import Keyboard.Extra   exposing (isPressed)
import Keyboard.Extra   as Keyboard
import ThrusterState    exposing (setThrusters)
import CollisionHandle  exposing (collisionsHandle)
import Refresh          exposing (refresh)

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

update : Msg -> Model -> (Model, Cmd Msg)
update msg m =
  case msg of 

    CheckForCollisions dt ->
      (collisionsHandle (dt / 120) m, Cmd.none)

    Refresh dt ->
      if m.paused then (m, Cmd.none)
      else
        (refresh (dt / 120) m, Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg m.keys
      in
        (handleKeys m keys, Cmd.map HandleKeys kCmd)

    Pause ->
      ({ m | paused = not m.paused }, Cmd.none)

handleKeys : Model -> Keyboard.Model -> Model
handleKeys m keys =
  let s = m.ship in
  { m
  | keys = keys
  , ship = 
    { s | thrusters = setThrusters keys }
  , paused = 
      if isPressed Keyboard.CharP keys then
        not m.paused
      else
        m.paused
   }







