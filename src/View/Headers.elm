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
        [ css [ marginBottom (Text.scale 4) ] ]
        [ Html.div
            [ css
                [ backgroundImage <|
                    linearGradient2
                        (deg 90)
                        (stop Colors.peach)
                        (stop Colors.orange)
                        []
                , height (px 5)
                , marginBottom (Text.scale 1)
                ]
            ]
            []
        , navBar [ Text.a ]
        ]


navBar : List (Attribute Msg) -> Html Msg
navBar attrs =
    Html.div
        (css
            [ width Text.fullSize
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
            [ padding (Text.scale 0.5)
            , firstChild [ paddingLeft zero ]
            , lastChild [ paddingRight zero ]
            , textDecoration none
            ]
            :: attrs
        )
        [ Html.text caption ]
