module Source exposing (..)

root : String
--root = "https://raw.githubusercontent.com/Chadtech/elm-prac-9/master/public/"
root = "./"

src : String -> String
src str = root ++ str ++ ".png"
