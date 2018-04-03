module View exposing (view)

import App exposing (Model, Msg(..))
import Html as RootHtml
import Html.Styled as Html exposing (Html)
import Page exposing (Page)
import Page.Content.View exposing (root)
import View.Elements as Elements
import View.Headers as Headers


view : Model -> RootHtml.Html Msg
view model =
    Html.toUnstyled <|
        Elements.container
            [ case ( model.route, model.page ) of
                ( Just _, Ok inner ) ->
                    content inner

                ( Nothing, _ ) ->
                    Html.text "TODO nice 404 page"

                ( _, Err err ) ->
                    -- TODO: nice 500 page
                    Html.text <| toString err
            ]


content : Page -> Html Msg
content page =
    Html.div []
        [ Headers.innerPage
        , root page.content
        ]
