module Update where


import Signal exposing (Address)


import Types exposing (Action(..), Chat)


update : Action -> Chat -> Chat
update action model =
  case action of
    SendMessage msg ->
      { model | field <- "" }

    Incoming msgs ->
      { model | messages <- msgs }

    Input say ->
      { model | field <- say }

    SetName name ->
      { model | name <- name }

    NoOp -> model
