module View exposing (view)

import Html.Styled as Html exposing (Html)
import Page.Content.View exposing (root)
import Route
import Route.Navigation as Navigation exposing (Model, Msg)
import View.Elements as Elements


view : Model -> Html Msg
view model =
    let
        current =
            Navigation.current model
    in
    Elements.container
        [ Elements.header
            [ ( "elm-conf", Route.index )
            , ( "About", Route.about )
            , ( "Speak at elm-conf", Route.speakAtElmConf )
            ]
        , root current.page.content
        ]
