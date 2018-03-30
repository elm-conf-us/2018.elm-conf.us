module App
    exposing
        ( Model
        , Msg(..)
        , Problem(..)
        , init
        , view
        )

import Html.Styled as Html exposing (Html)
import Json.Decode exposing (Value, decodeValue)
import Navigation
import Page
import Route exposing (Route)
import Route.Navigation
import View


type alias Model =
    Result Problem Route.Navigation.Model


type Problem
    = BadRoute
    | BadPage String


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


type Msg
    = NewRoute (Maybe Route)
    | NavigationMsg Route.Navigation.Msg


view : Model -> Html Msg
view res =
    case res of
        Ok inner ->
            Html.map NavigationMsg <| View.view inner

        Err BadRoute ->
            Html.text "TODO nice 404 page"

        Err (BadPage err) ->
            -- TOOD: nice 500 page
            Html.text err
