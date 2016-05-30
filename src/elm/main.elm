import Html             exposing (p, text)
import Html.Attributes  exposing (class)
import Html.App         as App
import Types            exposing (..)
import Ports            exposing (..)
import View             exposing (view)
import Time             exposing (..)
import Debug            exposing (log)
import AnimationFrame   exposing (..)

main =
  App.program
  { init          = (World frege, Cmd.none) 
  , view          = view
  , update        = update
  , subscriptions = subscriptions
  }

subscriptions : World -> Sub Msg
subscriptions model =
  diffs Refresh

update : Msg -> World -> (World, Cmd Msg)
update msg world =
  case msg of 

    Refresh t ->
      (world, Cmd.none)


