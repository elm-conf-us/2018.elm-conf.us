module View exposing (view)

import App exposing (Model, Msg(..))
import Html as RootHtml
import Html.Styled as Html exposing (Html)
import Page exposing (Page)
import Page.Content.View exposing (root)
import Route
import View.Elements as Elements


view : Model -> RootHtml.Html Msg
view model =
    Html.toUnstyled <|
        case ( model.route, model.page ) of
            ( Just _, Ok inner ) ->
                content inner

            ( Nothing, _ ) ->
                Html.text "TODO nice 404 page"

            ( _, Err err ) ->
                -- TODO: nice 500 page
                Html.text <| toString err


content : Page -> Html Msg
content page =
    Elements.container
        [ Elements.header
            [ ( "elm-conf", Route.index )
            , ( "About", Route.about )
            , ( "Speak at elm-conf", Route.speakAtElmConf )
            ]
        , root page.content
        ]
