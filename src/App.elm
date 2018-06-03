port module App
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


port setTitle : String -> Cmd msg


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
                    Err <|
                        Http.BadPayload problems
                            { url = ""
                            , status = { code = -1, message = "" }
                            , body = ""
                            , headers = Dict.empty
                            }
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
        NewRoute (Just (Internal route)) ->
            case Dict.get route.json model.cache of
                Just ({ frontMatter } as page) ->
                    ( { model
                        | page = Ok page
                        , route = Just (Internal route)
                      }
                    , setTitle frontMatter.title
                    )

                Nothing ->
                    ( { model | route = Just (Internal route) }
                    , Http.get route.json Page.decoder
                        |> Http.toTask
                        |> Task.map (\page -> ( route.json, page ))
                        |> Task.attempt NewPage
                    )

        NewRoute route ->
            -- this is what happens when we either navigate to page we don't
            -- control or fail to parse (very fine difference there...) The
            -- result is the same: 404 page!
            ( { model | route = route }, Cmd.none )

        GoTo (External route) ->
            ( model, Navigation.load route )

        GoTo (Internal route) ->
            ( model, Navigation.newUrl route.html )

        NewPage (Ok ( key, { frontMatter } as page )) ->
            ( { model
                | page = Ok page
                , cache = Dict.insert key page model.cache
              }
            , setTitle frontMatter.title
            )

        NewPage (Err err) ->
            ( { model | page = Err err }
            , Cmd.none
            )
