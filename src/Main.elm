module Main exposing (..)

import App exposing (..)
import Html.Styled as Styled
import Json.Decode exposing (Value, decodeValue)
import Navigation
import Page
import Route
import Route.Navigation


init : Value -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        routeRes =
            Route.parser location

        pageRes =
            decodeValue Page.decoder flags
    in
    case ( routeRes, pageRes ) of
        ( Just route, Ok page ) ->
            Route.Navigation.init route page
                |> Tuple.mapFirst Ok
                |> Tuple.mapSecond (Cmd.map NavigationMsg)

        ( Nothing, _ ) ->
            ( Err BadRoute, Cmd.none )

        ( _, Err err ) ->
            ( Err (BadPage err), Cmd.none )


main : Program Value Model Msg
main =
    Navigation.programWithFlags
        (NewRoute << Route.parser)
        { init = init
        , update = \_ page -> ( page, Cmd.none )
        , view = Styled.toUnstyled << view
        , subscriptions = \_ -> Sub.none
        }
