module Main exposing (..)

import App exposing (..)
import Json.Decode exposing (Value)
import Navigation
import Route


main : Program Value Model Msg
main =
    Navigation.programWithFlags
        (NewRoute << Route.parser)
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
