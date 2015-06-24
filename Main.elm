module Main where


import Html exposing (Html)
import Signal exposing (Address, Mailbox, merge)


import Api exposing (currentMessages)
import Model exposing (model)
import Update exposing (update)
import Types exposing (Action(NoOp))
import View exposing (view)


main : Signal Html
main =
  Signal.map (view actions.address) mergedModel


actions : Mailbox Action
actions =
  Signal.mailbox NoOp


mergedModel =
  Signal.foldp
    update
    model
    (merge actions.signal currentMessages.signal)
