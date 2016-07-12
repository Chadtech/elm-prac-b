module ReadOut exposing (readOut)

import Html             exposing (..)
import Html.Attributes  exposing (..)
import Html.Events      exposing (..)
import Types            exposing (..)
import Components       exposing (..)
import List             exposing (unzip, map)
import String           exposing (slice, length)


readOut : Ship -> Html Msg
readOut s =
  let
    (keys, values) = content s
  in
  div
  [ class "read-out-container" ]
  [ point "READ OUT"
  , column (map point keys)
  , column (map point values)
  ]

column : List (Html Msg) -> Html Msg
column list =
  div [ class "read-out-column" ] list

content : Ship -> (List String, List String)
content s =
  let (sx, sy) = s.sector in
  unzip
  [ "--------"  . "--------"
  , "STATUS"    . "NOMINAL"
  , "--------"  . "--------"
  , "ang vel "  . ((nf 4 (-s.va * (10/9))) ++ " rpm")
  , "velocity"  . nf 8 ((((s.vx ^ 2) + (s.vy ^ 2)) ^ 0.5)/10)
  --, "dir"       . "xxxxxxxx"
  , "dir"         . (((pad << (nf 5) << toFloat << round) (((atan2 s.vx s.vy) / pi) * 200)) ++ "/200")
  --, "dir"       . nf (sin ((s.vy / s.vx) / (((s.vx ^ 2) + (s.vy ^ 2)) ^ 0.5)))
  , "position"  . "--------"
  , ": angle"   . (((pad << (nf 5) << toFloat << round) (-s.a / 0.9)) ++ "/200")
  , ": x"       . nf 8 s.gx
  , ": y"       . nf 8 s.gy
  , "--------"  . "--------"
  , "FUEL"      . ((nf 6 (round' s.fuel))   ++ "l")
  , "OXYGEN"    . ((nf 6 (round' s.oxygen)) ++ "l")
  , "WEIGHT"    . ((nf 6 (round' s.weight)) ++ " yH")
  ]

(.) = (,)

cut : Int -> String -> String
cut limit str =
  if length str > limit then 
    slice 0 limit str 
  else str

pad : String -> String
pad s =
  if length s >= 4 then s
  else pad (s ++ "_")

nf : Int -> Float -> String
nf i f = cut i (toString f)

round' : Float -> Float
round' f = (toFloat (round (f * 10))) / 10
