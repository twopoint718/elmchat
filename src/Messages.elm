module Messages exposing (Msg(..))

import Model exposing (ChatMessage, ChatList)

type Msg
  = SendMessage ChatMessage
  | Incoming ChatList
  | Input String
  | PollMessages
  | SetName String
