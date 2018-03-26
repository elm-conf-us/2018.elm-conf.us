module Main exposing (..)

import Elements.Content as Content
import Html exposing (Html)
import Html.Styled as Styled
import Json.Decode exposing (Value, decodeValue)
import Page exposing (Page)


view : Result String Page -> Html msg
view res =
    case res of
        Ok { content } ->
            Styled.toUnstyled (Content.root content)

        Err err ->
            Html.text err


main : Program Value (Result String Page) msg
main =
    Html.programWithFlags
        { init = \flags -> ( decodeValue Page.decoder flags, Cmd.none )
        , update = \_ page -> ( page, Cmd.none )
        , view = view
        , subscriptions = \_ -> Sub.none
        }
