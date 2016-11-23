module View exposing (view)


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (WebData, RemoteData(..))

import Messages exposing (Msg(SendMessage, Input, SetName))
import Model exposing (Chat, ChatMessage, ChatList)

view : Chat -> Html Msg
view model =
  div [ class "container" ]
    [ stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    , stylesheet "css/style.css"
    , stylesheet "http://fonts.googleapis.com/css?family=Special+Elite"
    , row_
      [ h1 [class "col-xs-7"] [ text "Can We Talk!?" ]
      , div [class "col-xs-5"] [ img [src "images/joan.png"] [] ]
      ]
    , row_ [ errors model.messages ]
    , row_ [ inputControls model ]
    , row_ [ messageList model.messages ]
    ]


inputControls : Chat -> Html Msg
inputControls model =
  fieldset []
    [ legend [] [ text "Add Message" ]
    , Html.form
      [ class "form-horizontal"
      , onSubmit (mkMessage model |> SendMessage)
      ]
      [ formGroup_ (labeledField "name" "Name" "Your Name" model.name SetName )
      , formGroup_ (labeledField "say" "Say" "Enter a message" model.saying Input )
      , btnPrimary_ "Send"
      ]
    ]

labeledField : String -> String -> String -> String -> (String -> Msg) -> List (Html Msg)
labeledField id_ text_ placeholder_ value_ msg_ =
  [ label
    [ for id_
    , class "col-sm-1"
    ]
    [ text text_ ]
  , input
    [ id id_
    , class "form-control col-sm-9"
    , placeholder placeholder_
    , value value_
    , onInput msg_
    ]
    []
  ]


errors : WebData a -> Html b
errors messages =
  let
      content =
        case messages of
          NotAsked -> []
          Loading -> []
          Success _ -> []
          Failure e ->
            [ text <| toString e ]
  in
    p [ class "text-danger" ] content


mkMessage : Chat -> ChatMessage
mkMessage m =
  { name = m.name
  , message = m.saying
  }


messageList : ChatList -> Html a
messageList messages =
  case messages of
    NotAsked ->
      notTable "Loading..."
    Loading ->
      notTable "Loading..."
    Failure e ->
      notTable "Loading failed"
    Success s ->
      let
          messages_ =
            s
              |> List.reverse
              |> List.take 30
              |> List.map msgRow
      in
        zebraTable
          [ th [ class "col-xs-2" ] [ text "Name" ]
          , th [] [ text "Message" ]
          ] messages_

msgRow : ChatMessage -> Html a
msgRow msg =
  tr []
    [ td [] [ em [] [ text msg.name ] ]
    , td [] [ text msg.message ]
    ]

stylesheet : String -> Html a
stylesheet href_ =
  node "link" [ rel "stylesheet", href href_] []

notTable : String -> Html a
notTable content =
  div [ class "col-xs-12" ]
    [ aside [] [ text content ]
    ]

-- From Bootstrap


row_ : List (Html a) -> Html a
row_ =
  div [ class "row" ]


formGroup_ : List (Html a) -> Html a
formGroup_ =
  div [ class "form-group" ]


btnPrimary_ : String -> Html a
btnPrimary_ label =
  button [ class "btn btn-primary" ] [ text label ]

zebraTable : List (Html a) -> List (Html a) -> Html a
zebraTable headers bodies =
  table
    [ class "table col-xs-10 table-striped" ]
    [ thead [] [ tr [] headers ]
    , tbody [] bodies
    ]
