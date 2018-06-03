module View exposing (view)

import App exposing (Model, Msg(..))
import Html as RootHtml
import Html.Styled as Html exposing (Html)
import Page.View
import View.Elements as Elements
import View.Footer as Footer
import View.Headers as Headers


view : Model -> RootHtml.Html Msg
view model =
    Html.toUnstyled <|
        Elements.container
            [ case ( model.route, model.page ) of
                ( Just route, Ok inner ) ->
                    Html.div []
                        [ Headers.forPage route
                        , Page.View.view route inner
                        , Footer.footer
                        ]

                ( Nothing, _ ) ->
                    Html.text "TODO nice 404 page"

                ( _, Err err ) ->
                    -- TODO: nice 500 page
                    Html.text <| toString err
            ]
