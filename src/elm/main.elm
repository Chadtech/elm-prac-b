import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Init             exposing (initModel)
import AnimationFrame   exposing (..)
import Keyboard.Extra   as Keyboard
import CollisionHandle  exposing (collisionsHandle)
import Refresh          exposing (refresh)
import HandleKeys       exposing (handleKeys)

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
            let dt' = rate dt in
            m
            |>collisionsHandle dt' 
            |>refresh dt'
        in (m', Cmd.none)

    HandleKeys keyMsg ->
      let
        (keys, kCmd) = 
          Keyboard.update keyMsg m.keys
      in
        (handleKeys m keys, Cmd.map HandleKeys kCmd)

    Pause b ->
      ({ m | paused = b }, Cmd.none)



