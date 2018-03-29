module View exposing (view)

import Html.Styled as Html exposing (Html)
import Page exposing (Page)
import Page.Content.View exposing (root)
import Route
import View.Elements as Elements


view : Result String Page -> Html msg
view res =
    case res of
        Ok { content } ->
            Elements.container
                [ Elements.header
                    [ ( "elm-conf", Route.index )
                    , ( "About", Route.about )
                    , ( "Speak at elm-conf", Route.speakAtElmConf )
                    ]
                , root content
                ]

        Err err ->
            Html.text err
