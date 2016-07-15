module NavMarkers exposing (navMarkers)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Collage          exposing (..)
import Element          exposing (..)
import Transform        exposing (..)
import List             exposing (filter, map, concat, append)
import Pather           exposing (root)


navMarkers : Model -> Html Msg
navMarkers m =
  let 
    s = m.ship
    markers =
      concat
      [ thingMarkers m
      , [ northMarker ]
      , [ directionMarker s.dir ]
      ]
  in
  markers
  |>collage 600 600
  |>toForm
  |>rotate (degrees -s.a)
  |>\l -> l :: []
  |>collage 600 600 
  |>toHtml 

directionMarker : Float -> Form
directionMarker dir =
  "markers/direction"
  |>image' 20 20
  |>move ((sin dir) * r, (cos dir) * r)
  |>rotate -dir

northMarker : Form
northMarker = 
  "markers/north"
  |>image' 20 20
  |>move (0, r)

thingMarkers : Model -> List Form
thingMarkers m =
  let sg = (m.ship.gx, m.ship.gy)
  in
    m.things
    |>filter (nearEnough sg)
    |>map (drawThing sg)

drawThing : (Float, Float) -> Thing -> Form
drawThing (sgx, sgy) t =
  let 
    dx  = sgx - t.gx
    dy  = sgy - t.gy
    dir = atan2 dx dy
    x   = (sin dir) * -r
    y   = (cos dir) * -r
  in
  "markers/yellow"
  |>image' 20 20 
  |>move (x, y)

nearEnough : (Float, Float) -> Thing -> Bool
nearEnough (sgx,sgy) t =
  let
    dx = abs (sgx - t.gx)
    dy = abs (sgy - t.gy)
    nearEnoughX = dx < 6000 && 300 < dx
    nearEnoughY = dy < 6000 && 300 < dy
  in 
  nearEnoughX || nearEnoughY

image' : Int -> Int -> String -> Form
image' w h src = 
  root src |> image w h |> toForm

r : Float
r = 290

