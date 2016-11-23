module Model exposing (..)

import RemoteData exposing (RemoteData(NotAsked), WebData)

type alias Chat =
  { messages : ChatList
  , saying : String
  , name : String
  }

model : Chat
model =
  { messages = NotAsked
  , saying = ""
  , name = ""
  }

type alias ChatList =
  WebData (List ChatMessage)

type alias Name = String
type alias Message = String

type alias ChatMessage =
  { name : Name
  , message : Message
  }
