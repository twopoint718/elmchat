module Main exposing (..)


import Html
import Time exposing (second, every)

import Model exposing (model)
import Update exposing (update)
import View exposing (view)
import Types exposing (Msg(PollMessages))
import Model exposing (Model)
import Task

prefetchMessages : Cmd Msg
prefetchMessages =
  Task.perform
    (always PollMessages)
    (Task.succeed ())


init : (Model, Cmd Msg)
init = (model, prefetchMessages)

messageSubscription : Model -> Sub Msg
messageSubscription _ =
  every (5 * second) (always PollMessages)


main : Program Never Model Msg
main =
  Html.program
    { init = init, update = update, view = view, subscriptions = messageSubscription }
