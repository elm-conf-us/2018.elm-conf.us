module App
    exposing
        ( Model
        , Msg(..)
        , init
        , update
        )

import Html as RootHtml
import Http
import Json.Decode exposing (Value, decodeValue)
import Navigation
import Page exposing (Page)
import Route exposing (Route(..))
import Task


type alias Model =
    { route : Maybe Route
    , page : Result Http.Error Page
    }


type Msg
    = GoTo Route
    | NewRoute (Maybe Route)
    | NewPage (Result Http.Error Page)


init : Value -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    ( { route = Route.parser location
      , page =
            case decodeValue Page.decoder flags of
                Ok page ->
                    Ok page

                Err problems ->
                    -- TODO: use an accurate error
                    Err Http.Timeout
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
            ( model
            , Cmd.batch
                [ Navigation.newUrl route.html
                , Http.get route.json Page.decoder
                    |> Http.toTask
                    |> Task.attempt NewPage
                ]
            )

        NewPage page ->
            ( { model | page = page }, Cmd.none )
