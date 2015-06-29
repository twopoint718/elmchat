module Main where


import Html exposing (Html)
import Signal exposing (Address, Mailbox, mergeMany)
import Task exposing (Task, andThen, succeed, fail)
import Time exposing (every, second)


import Api exposing
  ( currentMessages
  , getMessages
  , outgoingMessages
  , postMessage
  , queryHandler
  )
import Model exposing (model)
import Update exposing (update)
import Types exposing (Action(NoOp), Chat)
import View exposing (view)


main : Signal Html
main =
  Signal.map (view actions.address) mergedModel


actions : Mailbox Action
actions =
  Signal.mailbox NoOp


mainSignal : Signal Action
mainSignal =
  mergeMany
    [ actions.signal
    , currentMessages.signal
    , outgoingMessages.signal
    ]


mergedModel : Signal Chat
mergedModel =
  Signal.foldp update model mainSignal


-- Ports


port runQuery : Signal (Task x ())
port runQuery =
  Signal.map (\_ -> getMessages) (Time.every (5 * second))
    |> Signal.map queryHandler


port sendMessage : Signal (Task String ())
port sendMessage =
  let actionHandler act = case act of
        SendMessage msg ->
          postMessage msg `andThen` (\res -> succeed ())

        _ ->
          fail "Nothing to do"
  in
      Signal.map actionHandler outgoingMessages.signal
