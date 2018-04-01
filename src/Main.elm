module Main exposing (..)

import App exposing (Model, Msg(..), init, update)
import Json.Decode exposing (Value)
import Navigation
import Route
import View exposing (view)


main : Program Value Model Msg
main =
    Navigation.programWithFlags
        (NewRoute << Route.parser)
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
