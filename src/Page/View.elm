module Page.View exposing (content)

import App exposing (Msg)
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Page exposing (Content(..), Page)
import Page.Content.View exposing (root)
import Route exposing (Route)
import Styles.Breakpoints as Breakpoints
import Styles.Text as Text


content : Route -> Page -> Html Msg
content route ({ frontMatter } as page) =
    let
        heading : Html Msg
        heading =
            if route == Route.index then
                -- this is taken care of by the fancy heading
                Html.text ""
            else
                Html.h1 [ Text.h1 ] [ Html.text frontMatter.title ]

        body : List (Html Msg)
        body =
            case page.content of
                Single single ->
                    root single

                Section section ->
                    -- TODO
                    []
    in
    Html.main_
        [ css
            [ Css.maxWidth Text.wideColumnSize
            , Css.margin2 Css.zero Css.auto
            , Breakpoints.belowWideColumnSize [ Css.padding2 Css.zero <| Text.scale 1 ]
            ]
        ]
        (heading :: body)
