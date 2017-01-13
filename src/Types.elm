module Types exposing (Msg(..), Chat, ChatMessage)

import Http


type Msg
    = SendMessage ChatMessage
    | Incoming (Result Http.Error (List ChatMessage))
    | Input String
    | NoOp
    | PollMessages
    | PostedMessage (Result Http.Error ())
    | SetName String


type alias ChatMessage =
    { name : String, message : String }


type alias Chat =
    { messages : List ChatMessage
    , errorMessage : String
    , field : String
    , name : String
    }
