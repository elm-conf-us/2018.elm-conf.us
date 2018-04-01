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
    { toRefactor : Result Problem Route.Navigation.Model
    , route : Maybe Route
    }


type Problem
    = FakeProblemToRefactor
    | BadPage String


init : Value -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        pageRes =
            decodeValue Page.decoder flags

        ( toRefactor, msg ) =
            case pageRes of
                Ok page ->
                    Route.Navigation.init page
                        |> Tuple.mapFirst Ok
                        |> Tuple.mapSecond (Cmd.map NavigationMsg)

                Err err ->
                    ( Err (BadPage err), Cmd.none )
    in
    ( { toRefactor = toRefactor
      , route = Route.parser location
      }
    , msg
    )


type Msg
    = NewRoute (Maybe Route)
    | NavigationMsg Route.Navigation.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRoute route ->
            ( { model | route = route }, Cmd.none )

        NavigationMsg subMsg ->
            let
                ( toRefactor, newMsg ) =
                    model.toRefactor
                        |> Result.map (Route.Navigation.update subMsg)
                        |> Result.map
                            (\( innerModel, innerMsg ) ->
                                ( Ok innerModel
                                , Cmd.map NavigationMsg innerMsg
                                )
                            )
                        |> Result.withDefault ( model.toRefactor, Cmd.none )
            in
            ( { model | toRefactor = toRefactor }, newMsg )


view : Model -> RootHtml.Html Msg
view model =
    Html.toUnstyled <|
        case ( model.route, model.toRefactor ) of
            ( Just _, Ok inner ) ->
                Html.map NavigationMsg <| View.view inner

            ( Nothing, _ ) ->
                Html.text "TODO nice 404 page"

            ( _, Err err ) ->
                -- TODO: nice 500 page
                Html.text <| toString err
