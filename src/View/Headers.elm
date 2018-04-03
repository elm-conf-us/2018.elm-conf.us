module View.Headers exposing (innerPage)

import App exposing (Msg)
import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Route exposing (Route)
import Styles.Colors as Colors
import Styles.Text as Text
import View.Elements as Elements


innerPage : Html Msg
innerPage =
    Html.header
        [ css [] ]
        [ Html.div
            [ css
                [ backgroundColor Colors.pink
                , height (px 5)
                , marginBottom (Text.scale 1)
                ]
            ]
            []
        , navBar [ css [ color Colors.pink ] ]
        ]


navBar : List (Attribute Msg) -> Html Msg
navBar attrs =
    Html.div
        (css
            [ width (px 900)
            , margin2 zero auto
            , displayFlex
            , justifyContent spaceBetween
            , alignItems center
            ]
            :: attrs
        )
        [ navLogo attrs
        , navLinks attrs
        ]


navLogo : List (Attribute Msg) -> Html Msg
navLogo attrs =
    navLink
        (css
            [ fontSize (Text.scale 2)
            , fontWeight (int 600)
            ]
            :: attrs
        )
        "elm-conf"
        Route.index


navLinks : List (Attribute Msg) -> Html Msg
navLinks attrs =
    Html.nav
        attrs
        [ navLink attrs "about" Route.about
        , navLink attrs "speak at elm-conf" Route.speakAtElmConf
        ]


navLink : List (Attribute Msg) -> String -> Route -> Html Msg
navLink attrs caption route =
    Elements.link
        route
        (css
            [ marginLeft (Text.scale 0.5)
            , textDecoration none
            ]
            :: attrs
        )
        [ Html.text caption ]
