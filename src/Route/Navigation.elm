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
import Page exposing (Page)
import Route exposing (Route)


type alias Current =
    { route : Route
    , page : Page
    }


type Model
    = Model
        { current : Current
        , cache : Dict String Page
        }


init : Route -> Page -> ( Model, Cmd Msg )
init route page =
    ( Model
        { current = Current route page
        , cache = Dict.empty
        }
    , Cmd.none
    )


{-| yes, this is a getter. But I feel OK with it in the interests of not exposing
the cache.
-}
current : Model -> Current
current (Model model) =
    model.current


type Msg
    = NewRoute Route


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (Model model) =
    case msg of
        NewRoute route ->
            let
                old =
                    model.current
            in
            ( Model { model | current = { old | route = route } }
            , Cmd.none
            )
