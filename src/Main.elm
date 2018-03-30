module Main exposing (..)

import App exposing (..)
import Html.Styled as Styled
import Json.Decode exposing (Value)
import Navigation
import Route


main : Program Value Model Msg
main =
    Navigation.programWithFlags
        (NewRoute << Route.parser)
        { init = init
        , update = \_ page -> ( page, Cmd.none )
        , view = Styled.toUnstyled << view
        , subscriptions = \_ -> Sub.none
        }
