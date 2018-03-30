module App exposing (Model, Msg(..), Problem(..), view)

import Html.Styled as Html exposing (Html)
import Route exposing (Route)
import Route.Navigation
import View


type Problem
    = BadRoute
    | BadPage String


type alias Model =
    Result Problem Route.Navigation.Model


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
