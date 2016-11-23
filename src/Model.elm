module Model exposing (Chat, ChatList, ChatMessage, model)

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

type alias ChatMessage =
  { name : String
  , message : String
  }
