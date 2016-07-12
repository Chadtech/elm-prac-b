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
  , "dir"       . (angleFormat (((atan2 s.vx s.vy) / pi) * 200))
  , "position"  . "--------"
  , ": angle"   . (angleFormat (-s.a / 0.9))
  , ": x"       . nf 8 s.gx
  , ": y"       . nf 8 s.gy
  , "--------"  . "--------"
  , "FUEL"      . ((nf 6 (oneDecimal s.fuel))   ++ "l")
  , "OXYGEN"    . ((nf 6 (oneDecimal s.oxygen)) ++ "l")
  , "WEIGHT"    . ((nf 6 (oneDecimal s.weight)) ++ " yH")
  ]

(.) = (,)

angleFormat : Float -> String
angleFormat =
  round
  >>toFloat
  >>nf 5
  >>pad
  >>(\s -> s ++ "/200")

pad : String -> String
pad s =
  if length s >= 4 then s
  else pad (s ++ "_")

-- Number Format
nf : Int -> Float -> String
nf i f = 
  let s = toString f in
  if length s > i then slice 0 i s 
  else s

oneDecimal : Float -> Float
oneDecimal f = (toFloat (round (f * 10))) / 10
