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
import Debug            exposing (log)


navMarkers : Model -> Html Msg
navMarkers m =
  let 
    s = m.ship
    markers =
      concat
      [ [ northMarker ]
      , [ directionMarker s.dir ]
      , thingMarkers m
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
  |>marker
  |>move ((sin dir) * r, (cos dir) * r)
  |>rotate -dir

northMarker : Form
northMarker = 
  "markers/north"
  |>marker
  |>move (0, r)

thingMarkers : Model -> List Form
thingMarkers m =
  let s = m.ship in
  m.things
  |>filter (nearEnough (s.gx, s.gy))
  |>map (drawThing m.ship)

drawThing : Ship -> Thing -> Form
drawThing s t =
  let 
    rvx = s.vx - t.vx
    rvy = s.vy - t.vy
    rv  = sqrt ((rvx^2) + (rvy^2))
    dir = atan2 rvx rvy

    dx   = s.gx - t.gx
    dy   = s.gy - t.gy

    pos  = atan2 dx dy
    x    = (sin pos) * -r
    y    = (cos pos) * -r

    markerType =
      if rv < 80 then
        if rv < 40 then "normal"
        else "highlight"
      else "urgent"
  in
  "markers/thing-" ++ markerType
  |>marker
  |>move (x, y)
  |>rotate (pi - dir)

nearEnough : (Float, Float) -> Thing -> Bool
nearEnough (sgx,sgy) t =
  let
    dx   = sgx - t.gx
    dy   = sgy - t.gy
    dist = sqrt ((dx^2) + (dy^2))
  in 
  dist < 12000 && 300 < dist

marker : String -> Form
marker src = 
  root src |> image 20 20 |> toForm

r : Float
r = 290

