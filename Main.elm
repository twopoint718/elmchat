module Main exposing (..)

import Html exposing (Html)
import Time exposing (second, every)
import Model exposing (model)
import Update exposing (update)
import View exposing (view)
import Types exposing (Chat, Msg(PollMessages))


init : ( Chat, Cmd msg )
init =
    ( model, Cmd.none )


messageSubscription : Chat -> Sub Msg
messageSubscription _ =
    every (5 * second) (always PollMessages)


main : Program Never Chat Msg
main =
    Html.program
        { init = init, update = update, view = view, subscriptions = messageSubscription }
