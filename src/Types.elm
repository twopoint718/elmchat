module Types exposing (Msg(..), Chat, ChatMessage)


import Http

import RemoteData exposing (WebData, RemoteData)

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
  { messages : WebData (List ChatMessage)
  , errorMessage : String
  , saying : String
  , name : String
  }
