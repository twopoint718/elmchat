module View where


import Array
import Html exposing (..)
import Html.Attributes as A
import Html.Events as E
import Html.Shorthand exposing (..)
import Json.Decode as Json
import Signal exposing (Address)


import Api exposing (outgoingMessages)
import Types exposing (Action(..), Chat, Message)


view : Address Action -> Chat -> Html
view address model =
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
  , h1_ "Can We Talk!?"
  , row_ [ inputControls address model ]
  , row_ [ messageList model ]
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
        , E.onKeyUp outgoingMessages.address (mkMessage model |> sendMessage)
        ]
        []
      ]
    , btnPrimary_ "Send"
      outgoingMessages.address (mkMessage model |> SendMessage)
    ]
  ]


mkMessage : Chat -> Message
mkMessage m =
  { name = m.name
  , message = m.field
  }


sendMessage : Message -> Int -> Action
sendMessage msg key =
  if key == 13 then SendMessage msg else NoOp


messageList : Chat -> Html
messageList model =
  let msgRow msg =
        tr_
          [ td_ [ em_ msg.name ]
          , td_ [ text msg.message ]
          ]
  in
      table
        [ A.class "table col-xs-10 table-striped" ]
        [ thead_
          [ tr_
            [ th [ A.class "col-xs-2" ] [ text "Name" ]
            , th_ [ text "Message" ]
            ]
          ]
        , tbody_ (List.map msgRow model.messages)
        ]


stylesheet : String -> Html
stylesheet href =
  node "link"
    [ A.rel "stylesheet"
    , A.href href
    ] []


-- From Bootstrap


row_ : List Html -> Html
row_ = div [ A.class "row" ]


container_ : List Html -> Html
container_ = div [ A.class "container" ]


formGroup_ : List Html -> Html
formGroup_ = div [ A.class "form-group" ]


btnPrimary_ : String -> Address a -> a -> Html
btnPrimary_ label addr x =
  button
  [ A.class "btn btn-primary"
  , E.onClick addr x
  ]
  [ text label ]
