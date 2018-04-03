module Page.View exposing (content)

import App exposing (Msg)
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Page exposing (Page)
import Page.Content.View exposing (root)
import Route exposing (Route)
import Styles.Text as Text


content : Route -> Page -> Html Msg
content route page =
    let
        heading =
            if route == Route.index then
                -- this is taken care of by the fancy heading
                Html.text ""
            else
                Html.h1 [ Text.h1 ] [ Html.text page.title ]
    in
    Html.main_
        [ css
            [ Css.width Text.wideColumnSize
            , Css.margin2 Css.zero Css.auto
            ]
        ]
        (heading :: root page.content)
