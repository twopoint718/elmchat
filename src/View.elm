module View exposing (..)


import Array
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Json

import Api
import Types exposing (Msg(..), Chat, ChatMessage)


view : Chat -> Html Msg
view model =
  container_
  [ stylesheet "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
  , stylesheet "css/style.css"
  , node "link"
    [ A.href "http://fonts.googleapis.com/css?family=Special+Elite"
    , A.rel "stylesheet"
    ]
    []
  , img [A.src "images/joan.png"]
    []
  , h1 [] [ text "Can We Talk!?" ]
  , row_ [ displayErrors model ]
  , row_ [ inputControls model ]
  , row_ [ messageList model ]
  ]


inputControls : Chat -> Html Msg
inputControls model =
  fieldset []
    [ legend [] [ text "Add Message" ]
    , form
      [ A.class "form-horizontal"
      , E.onSubmit (mkMessage model |> SendMessage)
      ]
      [ formGroup_
        [ label
          [ A.for "name"
          , A.class "col-sm-1"
          ]
          [ text "Name" ]
        , input
          [ A.id "name"
          , A.class "form-control"
          , A.class "col-sm-2"
          , A.placeholder "Your Name"
          , E.onInput SetName
          ]
          []
        ]
      , formGroup_
        [ label
          [ A.for "say"
          , A.class "col-sm-1"
          ]
          [ text "Say" ]
        , input
          [ A.id "say"
          , A.class "col-sm-9"
          , A.placeholder "Enter a message"
          , A.value model.field
          , E.onInput Input
          ]
          []
        ]
      , btnPrimary_ "Send"
      ]
    ]


displayErrors : Chat -> Html a
displayErrors model =
  p
    [ A.class "text-danger" ]
    [ text model.errorMessage ]


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
  let msgRow msg =
        tr []
          [ td [] [ em [] [ text msg.name ] ]
          , td [] [ text msg.message ]
          ]
  in
      table
        [ A.class "table col-xs-10 table-striped" ]
        [ thead []
          [ tr []
            [ th [ A.class "col-xs-2" ] [ text "Name" ]
            , th [] [ text "Message" ]
            ]
          ]
        , tbody [] (List.map msgRow model.messages)
        ]


stylesheet : String -> Html a
stylesheet href =
  node "link"
    [ A.rel "stylesheet"
    , A.href href
    ] []


-- From Bootstrap


row_ : List (Html a) -> Html a
row_ =
  div [ A.class "row" ]


container_ : List (Html a) -> Html a
container_ =
  div [ A.class "container" ]


formGroup_ : List (Html a) -> Html a
formGroup_ =
  div [ A.class "form-group" ]


btnPrimary_ : String -> Html a
btnPrimary_ label =
  button
  [ A.class "btn btn-primary"
  ]
  [ text label ]


onKeyUp : (Int -> msg) -> Attribute msg
onKeyUp tagger =
  E.on "keyup" (Json.map tagger E.keyCode)
