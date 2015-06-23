module Update where


import Array exposing (push)
import Signal exposing (Address)


import Types exposing (Action(..), Chat)


update : Action -> Chat -> Chat
update action model =
  case action of
    SendMessage ->
      { model |
        messages <-
          push { name = model.name, message = model.field } model.messages,
        field <- ""
      }

    Input say ->
      { model | field <- say }

    SetName name ->
      { model | name <- name }

    NoOp -> model
