module Messages exposing (Msg(..))

import Model exposing (..)

type Msg
  = SendMessage Name Message
  | Incoming ChatList
  | Input String
  | PollMessages
  | SetName String
