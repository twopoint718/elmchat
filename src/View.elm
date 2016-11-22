module View exposing (..)


import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import RemoteData exposing (WebData, RemoteData(..))

import Api
import Types exposing (Msg(..), Chat, ChatMessage)

view : Chat -> Html Msg
view model =
  div [ class "container" ]
    [ stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    , stylesheet "css/style.css"
    , stylesheet "http://fonts.googleapis.com/css?family=Special+Elite"
    , img [src "images/joan.png"] []
    , h1 [] [ text "Can We Talk!?" ]
    , row_ [ displayErrors model.messages ]
    , row_ [ inputControls model ]
    , row_ [ messageList model ]
    ]


inputControls : Chat -> Html Msg
inputControls model =
  fieldset []
    [ legend [] [ text "Add Message" ]
    , Html.form
      [ class "form-horizontal"
      , onSubmit (mkMessage model |> SendMessage)
      ]
      [ formGroup_ ( labeledField "name" "Name" "Your Name" model.name SetName )
      , formGroup_ (labeledField "say" "Say" "Enter a message" model.field Input )
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


displayErrors : WebData a -> Html b
displayErrors messages =
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
  , message = m.field
  }


sendMessageOnEnter : Int -> ChatMessage ->  Msg
sendMessageOnEnter key msg =
  if key == 13 then SendMessage msg else NoOp


messageList : Chat -> Html a
messageList model =
  table
    [ class "table col-xs-10 table-striped" ]
    [ thead []
      [ tr []
        [ th [ class "col-xs-2" ] [ text "Name" ]
        , th [] [ text "Message" ]
        ]
      ]
    , tbody [] (perhapsMessages model.messages)
    ]

msgRow : ChatMessage -> Html a
msgRow msg =
  tr []
    [ td [] [ em [] [ text msg.name ] ]
    , td [] [ text msg.message ]
    ]

perhapsMessages : WebData (List ChatMessage) -> List (Html a)
perhapsMessages msgs =
  case msgs of
    NotAsked ->
      [ tr []
          [ td [] [ text "not loaded" ] ]
      ]
    Loading ->
      [ tr []
          [ td [] [ text "loading" ] ]
      ]

    Failure e ->
      []

    Success messages ->
      List.map msgRow messages

stylesheet : String -> Html a
stylesheet href_ =
  node "link"
    [ rel "stylesheet"
    , href href_
    ] []


-- From Bootstrap


row_ : List (Html a) -> Html a
row_ =
  div [ class "row" ]


formGroup_ : List (Html a) -> Html a
formGroup_ =
  div [ class "form-group" ]


btnPrimary_ : String -> Html a
btnPrimary_ label =
  button
  [ class "btn btn-primary"
  ]
  [ text label ]
