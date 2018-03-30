module App
    exposing
        ( Model
        , Msg(..)
        , Problem(..)
        , init
        , update
        , view
        )

import Html as RootHtml
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRoute (Just route) ->
            update (NavigationMsg (Route.Navigation.NewRoute route)) model

        NewRoute Nothing ->
            ( Err BadRoute, Cmd.none )

        NavigationMsg subMsg ->
            model
                |> Result.map (Route.Navigation.update subMsg)
                |> Result.map
                    (\( innerModel, innerMsg ) ->
                        ( Ok innerModel
                        , Cmd.map NavigationMsg innerMsg
                        )
                    )
                |> Result.withDefault ( model, Cmd.none )


view : Model -> RootHtml.Html Msg
view res =
    Html.toUnstyled <|
        case res of
            Ok inner ->
                Html.map NavigationMsg <| View.view inner

            Err BadRoute ->
                Html.text "TODO nice 404 page"

            Err (BadPage err) ->
                -- TOOD: nice 500 page
                Html.text err
