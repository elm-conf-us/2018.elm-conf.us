module Main exposing (..)

import Html
import Html.Styled as Styled
import Json.Decode exposing (Value, decodeValue)
import Page exposing (Page)
import View exposing (view)


main : Program Value (Result String Page) msg
main =
    Html.programWithFlags
        { init = \flags -> ( decodeValue Page.decoder flags, Cmd.none )
        , update = \_ page -> ( page, Cmd.none )
        , view = Styled.toUnstyled << view
        , subscriptions = \_ -> Sub.none
        }
