module Page.View exposing (view)

import App exposing (Msg)
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Page exposing (Content(..), Page)
import Page.Content.View exposing (root)
import Route exposing (Route)
import Styles.Breakpoints as Breakpoints
import Styles.Text as Text


view : Route -> Page -> Html Msg
view route ({ frontMatter } as page) =
    let
        heading : Html Msg
        heading =
            if route == Route.index then
                -- this is taken care of by the fancy heading
                Html.text ""
            else
                Html.h1 [ Text.h1 ] [ Html.text frontMatter.title ]

        rules =
            [ Css.maxWidth Text.wideColumnSize
            , Css.margin2 Css.zero Css.auto
            , Breakpoints.belowWideColumnSize [ Css.padding2 Css.zero <| Text.scale 1 ]
            ]

        imagesRule =
            -- TODO: make this not a magic number
            Breakpoints.aboveFullSize [ Css.paddingLeft (Css.px 264) ]

        finalRules =
            if Page.hasImages page then
                imagesRule :: rules
            else
                rules
    in
    Html.main_
        [ css finalRules ]
        [ heading
        , root page
        ]
