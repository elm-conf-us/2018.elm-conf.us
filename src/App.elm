module App
    exposing
        ( Model
        , Msg(..)
        , init
        , update
        )

import Dict exposing (Dict)
import Http
import Json.Decode exposing (Value, decodeValue)
import Navigation
import Page exposing (Page)
import Route exposing (Route(..))
import Task


type alias Model =
    { route : Maybe Route
    , page : Result Http.Error Page
    , cache : Dict String Page
    }


type Msg
    = GoTo Route
    | NewRoute (Maybe Route)
    | NewPage (Result Http.Error ( String, Page ))


init : Value -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        route =
            Route.parser location

        pageRes =
            decodeValue Page.decoder flags
    in
    ( { route = route
      , page =
            case pageRes of
                Ok page ->
                    Ok page

                Err problems ->
                    -- TODO: use an accurate error
                    Err Http.Timeout
      , cache =
            case ( route, pageRes ) of
                ( Just (Internal { json }), Ok page ) ->
                    Dict.singleton json page

                _ ->
                    Dict.empty
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRoute route ->
            ( { model | route = route }, Cmd.none )

        GoTo (External route) ->
            ( model, Navigation.load route )

        GoTo (Internal route) ->
            case Dict.get route.json model.cache of
                Just page ->
                    ( { model | page = Ok page }
                    , Navigation.newUrl route.html
                    )

                Nothing ->
                    ( model
                    , Cmd.batch
                        [ Navigation.newUrl route.html
                        , Http.get route.json Page.decoder
                            |> Http.toTask
                            |> Task.map (\page -> ( route.json, page ))
                            |> Task.attempt NewPage
                        ]
                    )

        NewPage (Ok ( key, page )) ->
            ( { model
                | page = Ok page
                , cache = Dict.insert key page model.cache
              }
            , Cmd.none
            )

        NewPage (Err err) ->
            ( { model | page = Err err }, Cmd.none )
