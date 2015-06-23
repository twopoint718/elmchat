module Main where


import Html exposing (Html)
import StartApp


import Model exposing (model)
import View exposing (view)
import Update exposing (update)


main : Signal Html
main =
  StartApp.start { model = model, view = view, update = update }
