module Api exposing (pollMessages, sendMessage)

import Http exposing (Request)
import Json.Decode as Json exposing (field)
import Json.Encode exposing (Value, encode, object, string)
import Types
    exposing
        ( ChatMessage
        , Msg(Incoming, PostedMessage)
        )


endpoint : String
endpoint =
    "http://localhost:3000/messages"



-- GET


pollMessages : Cmd Msg
pollMessages =
    Http.send Incoming getMessages


getMessages : Request (List ChatMessage)
getMessages =
    Http.get endpoint messagesDecoder


messagesDecoder : Json.Decoder (List ChatMessage)
messagesDecoder =
    Json.list messageDecoder


messageDecoder : Json.Decoder ChatMessage
messageDecoder =
    Json.map2 (\name message -> { name = name, message = message })
        (field "name" Json.string)
        (field "message" Json.string)



-- POST


sendMessage : ChatMessage -> Cmd Msg
sendMessage msg =
    Http.send PostedMessage (postMessage msg)


postMessage : ChatMessage -> Request ()
postMessage msg =
    Http.request
        { method = "POST"
        , headers = []
        , url = endpoint
        , body =
            messageEncoder msg
                |> encode 0
                |> Http.stringBody "application/json"
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , timeout = Nothing
        , withCredentials = False
        }


messageEncoder : ChatMessage -> Json.Value
messageEncoder msg =
    object
        [ ( "name", string msg.name )
        , ( "message", string msg.message )
        ]
