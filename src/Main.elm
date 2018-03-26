module Main exposing (..)

import Html exposing (Html)
import Json.Decode exposing (Value, decodeValue)
import Page exposing (Page)


main : Program Value (Result String Page) msg
main =
    Html.programWithFlags
        { init = \flags -> ( decodeValue Page.decoder flags, Cmd.none )
        , update = \_ page -> ( page, Cmd.none )
        , view = Html.text << toString
        , subscriptions = \_ -> Sub.none
        }
