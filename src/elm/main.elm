import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Time             exposing (..)
import Debug            exposing (log)
import AnimationFrame   exposing (..)
import ShipPosition     exposing (position)
import Keyboard.Extra   as Keyboard
import ThrusterState    exposing (setThrusters)
import Thrust           exposing (setThrust)
import Set

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
  let s = m.ship
  in
  { m | ship = 
      s
      |>position dt
      |>setThrust
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 

    Refresh dt ->
      let dt' = dt / 120
      in
        (refresh model dt', Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys', kCmd) = 
          Keyboard.update keyMsg model.keys
        s = model.ship
      in
        (,)
          { model 
            | keys = keys'
            , ship = 
              { s 
                | thrusters = setThrusters keys'
              }
          } 
          (Cmd.map HandleKeys kCmd)

