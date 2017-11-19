module Web exposing (main)

-- Elm module import
import Html exposing (Html, program, div, h2, text)

-- Local module import
---- main module
import Model   exposing (Model, new)
import Message exposing (Message)

-- main
main =
  div [] [ h2 [] [ text "Hello, elm!" ] ]

{--
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
-- init
init : ( Model, Cmd Message )
init =
  ( Model.new, Cmd.none )
-- update
update : Message -> Model -> ( Model, Cmd Message )
update message model =
  ( model, Cmd.none )
-- view
view : Model -> Html Message
view model =
  div [] [ h2 [] [ text "Hello, elm!" ] ]
-- subscriptions
subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none
--}
