module Route.Navigation
    exposing
        ( Current
        , Model
        , Msg(..)
        , current
        , init
        , update
        )

import Dict exposing (Dict)
import Http
import Navigation
import Page exposing (Page)
import Route exposing (Route(..))
import Task


type alias Current =
    { page : Page }


type Model
    = Model
        { page : Page
        , cache : Dict String Page
        }


init : Page -> ( Model, Cmd Msg )
init page =
    ( Model
        { page = page
        , cache = Dict.empty
        }
    , Cmd.none
    )


{-| yes, this is a getter. But I feel OK with it in the interests of not exposing
the cache.
-}
current : Model -> Current
current (Model { page }) =
    Current page


type Msg
    = NewPage String String (Result Http.Error Page)
    | GoTo Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        -- NewRoute route ->
        --     ( Model { model | route = route }
        --     , Cmd.none
        --     )
        NewPage location display (Ok page) ->
            ( Model
                { model
                    | cache = Dict.insert location page model.cache
                    , page = page
                }
            , Navigation.newUrl display
            )

        NewPage _ _ (Err error) ->
            Debug.crash ("TODO: handle " ++ toString error)

        GoTo (External route) ->
            ( Model model
            , Navigation.load route
            )

        GoTo (Internal route) ->
            case Dict.get route.json model.cache of
                Just page ->
                    ( Model { model | page = page }
                    , Navigation.newUrl route.html
                    )

                Nothing ->
                    ( Model model
                    , Http.get route.json Page.decoder
                        |> Http.toTask
                        |> Task.attempt (NewPage route.json route.html)
                    )
