module Main exposing (main)

import Html
import Time exposing (second, every)

import Model exposing (Chat, model)
import Update exposing (update)
import View exposing (view)
import Messages exposing (Msg(PollMessages))
import Task

init : (Chat, Cmd Msg)
init = (model, prefetchMessages)

prefetchMessages : Cmd Msg
prefetchMessages =
  Task.perform
    (always PollMessages)
    (Task.succeed ())

subscriptions : Chat -> Sub Msg
subscriptions _ =
  every (5 * second) (always PollMessages)


main : Program Never Chat Msg
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
