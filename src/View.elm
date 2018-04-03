module View exposing (view)

import App exposing (Model, Msg(..))
import Html as RootHtml
import Html.Styled as Html exposing (Html)
import Page exposing (Page)
import Page.Content.View exposing (root)
import Route exposing (Route)
import View.Elements as Elements
import View.Headers as Headers


view : Model -> RootHtml.Html Msg
view model =
    Html.toUnstyled <|
        Elements.container
            [ case ( model.route, model.page ) of
                ( Just route, Ok inner ) ->
                    content route inner

                ( Nothing, _ ) ->
                    Html.text "TODO nice 404 page"

                ( _, Err err ) ->
                    -- TODO: nice 500 page
                    Html.text <| toString err
            ]


content : Route -> Page -> Html Msg
content active page =
    Html.div []
        [ Headers.forPage active
        , root page.content
        ]
