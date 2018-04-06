module View.Headers exposing (forPage)

import App exposing (Msg)
import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Route exposing (Route)
import Styles.Breakpoints as Breakpoints
import Styles.Colors as Colors
import Styles.Text as Text
import View.Elements as Elements


forPage : Route -> Html Msg
forPage active =
    if active == Route.index then
        frontPage
    else
        innerPage


spaceAfter : Attribute Msg
spaceAfter =
    css [ marginBottom (Text.scale 4) ]


frontPage : Html Msg
frontPage =
    Html.header
        [ spaceAfter
        , css
            [ backgroundImage <| linearGradient (stop Colors.orange) (stop Colors.peach) []
            , Breakpoints.belowFullSize
                [ padding2 zero <| Text.scale 1 ]

            -- TODO: restore this when we make the waves. The white helps with
            -- the transition. Removing for now so that it's not blocking
            -- shipping if we run out of time to do so.
            --
            -- linearGradient2
            --     (deg 0)
            --     (stop Colors.white)
            --     (stop2 Colors.peach <| Text.scale 2)
            --     [ stop Colors.orange ]
            ]
        ]
        [ navBar LightOnDark
        , Elements.spacer 5
        , Html.div
            [ css
                [ maxWidth Text.fullSize
                , margin2 zero auto
                , textAlign center
                ]
            ]
            [ Elements.elmLogo 4
                [ css
                    [ margin2 zero auto
                    , marginBottom <| Text.scale 1
                    ]
                ]
            , Html.h1
                [ Text.hero
                , css
                    [ paddingBottom <| Text.scale 3
                    , Breakpoints.belowWideColumnSize
                        [ fontSize (Text.scale 2) |> important
                        , lineHeight (Text.scale 3) |> important
                        ]
                    ]
                ]
                [ Html.text "elm-conf is a single-day, one-track conference for the Elm programming language community."
                , Html.br [] []
                , Html.text "Join us on September 26, 2018!"
                ]
            , Elements.linkGhostButton
                -- TODO: the right link here
                Route.speakAtElmConf
                [ Text.aReversed
                , css [ fontSize <| Text.scale 2 ]
                ]
                [ Html.text "submit a talk" ]
            ]
        , Elements.spacer 5
        ]


innerPage : Html Msg
innerPage =
    Html.header
        [ spaceAfter ]
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
        , navBar DarkOnLight
        ]


type NavVariant
    = DarkOnLight
    | LightOnDark


navBar : NavVariant -> Html Msg
navBar variant =
    Html.div
        [ css
            [ maxWidth Text.fullSize
            , margin2 zero auto
            , displayFlex
            , justifyContent spaceBetween
            , alignItems center
            , Breakpoints.belowFullSize
                [ flexDirection column ]
            ]
        ]
        [ navLogo variant
        , navLinks variant
        ]


navLogo : NavVariant -> Html Msg
navLogo variant =
    navLink variant Route.index <|
        Html.span
            [ css
                [ fontSize (Text.scale 2)
                , fontWeight (int 600)
                ]
            ]
            [ Html.text "elm-conf" ]


navLinks : NavVariant -> Html Msg
navLinks variant =
    Html.nav []
        [ navLink variant Route.about <| Html.text "about"
        , navLink variant Route.speakAtElmConf <| Html.text "speak at elm-conf"
        ]


navLink : NavVariant -> Route -> Html Msg -> Html Msg
navLink variant route caption =
    Elements.link
        route
        [ css
            [ padding (Text.scale 0.5)
            , firstChild [ paddingLeft zero ]
            , lastChild [ paddingRight zero ]
            ]
        , case variant of
            DarkOnLight ->
                Text.a

            LightOnDark ->
                Text.aReversed
        ]
        [ caption ]
