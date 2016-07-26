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
import Debug exposing (log)

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
  , response Pause
  ]

rate : Time -> Time
rate dt = dt / 240

update : Msg -> Model -> (Model, Cmd Msg)
update msg m =
  case msg of 

    Refresh dt ->
      if (m.paused || m.died) then 
        (m, Cmd.none)
      else
        let 
          m' =
            m
            |>collisionsHandle (rate dt) 
            |>refresh (rate dt) 
        in (m', Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg m.keys
      in
        (handleKeys m keys, Cmd.map HandleKeys kCmd)

    Pause b ->
      ({ m | paused = True }, Cmd.none)


handleKeys : Model -> Keyboard.Model -> Model
handleKeys m keys =
  let s = m.ship in
  if isPressed Keyboard.Enter keys then
    initModel
  else
  { m
  | keys = keys
  , ship = 
    { s | thrusters = 
      if not m.died then
        setThrusters keys 
      else s.thrusters
    }
  , paused = 
      if isPressed Keyboard.CharP keys then
        not m.paused
      else m.paused
   }







