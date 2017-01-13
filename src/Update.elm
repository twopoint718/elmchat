module Update exposing (..)

import Api
import Types exposing (Msg(..), Chat, ChatMessage)


update : Msg -> Chat -> ( Chat, Cmd Msg )
update msg model =
    case msg of
        SendMessage msg ->
            ( { model | field = "" }
            , Api.sendMessage msg
            )

        Incoming (Ok msgs) ->
            ( { model | messages = msgs, errorMessage = "" }
            , Cmd.none
            )

        Incoming (Err err) ->
            ( { model | errorMessage = toString err }
            , Cmd.none
            )

        PollMessages ->
            ( model
            , Api.pollMessages
            )

        PostedMessage (Ok _) ->
            ( model
            , Api.pollMessages
            )

        PostedMessage (Err err) ->
            ( { model | errorMessage = toString err }
            , Cmd.none
            )

        Input say ->
            ( { model | field = say }
            , Cmd.none
            )

        SetName name ->
            ( { model | name = name }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )
