module Types exposing (Msg(..))

import RemoteData exposing (WebData, RemoteData)
import Model exposing (ChatMessage)

type Msg
  = SendMessage ChatMessage
  | Incoming (WebData (List ChatMessage))
  | Input String
  | NoOp
  | PollMessages
  | SetName String
  | ShowError String
