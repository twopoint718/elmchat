module Types exposing (Msg(..), Chat, ChatMessage)


import Http

import RemoteData exposing (WebData)

type Msg
  = SendMessage ChatMessage
  | Incoming (WebData (List ChatMessage))
  | Input String
  | NoOp
  | PollMessages
  | SetName String
  | ShowError String


type alias ChatMessage
  = { name: String, message: String }


type alias Chat =
  { messages : List ChatMessage
  , errorMessage : String
  , field : String
  , name : String
  }
