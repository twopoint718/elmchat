module View where


import Array
import Bootstrap.Html exposing (..)
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Html.Shorthand exposing (..)
import Json.Decode as Json
import Signal exposing (Address)


import Types exposing (Action(..), Chat)


view : Address Action -> Chat -> Html
view address model =
  container_
  [ node "link"
    [ A.rel "stylesheet"
    , A.href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    ]
    []
  , h1_ "Can We Talk!?"
  , row_ [ messageList model ]
  , row_ [ inputControls address model ]
  ]


inputControls : Address Action -> Chat -> Html
inputControls address model =
  fieldset []
  [ legend_ "Add Message"
  , form
    [ A.class "form-horizontal"
    , A.action "#"
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
        , E.on "input" E.targetValue (Signal.message address << SetName)
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
        , E.on "input" E.targetValue (Signal.message address << Input)
        , E.onKeyUp address sendMessage
        ]
        []
      ]
    , btnDefault_
      { btnParam | label <- Just "Send" }
      address SendMessage
    ]
  ]


sendMessage : Int -> Action
sendMessage key =
  if key == 13 then SendMessage else NoOp


messageList : Chat -> Html
messageList model =
  let msgRow msg =
        tr_
          [ td_ [ em_ msg.name ]
          , td_ [ text msg.message ]
          ]
  in
      table
        [ A.class "table table-striped" ]
        [ thead_
          [ tr_
            [ th [ A.class "col-xs-2" ] [ text "Name" ]
            , th_ [ text "Message" ]
            ]
          ]
        , tbody_ (Array.toList (Array.map msgRow model.messages))
        ]
