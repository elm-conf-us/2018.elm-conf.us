module View.Elements
    exposing
        ( container
        , elmLogo
        , link
        , linkGhostButton
        , nav
        , spacer
        )

import App exposing (Msg(..))
import Css
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (css)
import Html.Styled.Events as Events exposing (defaultOptions)
import Json.Decode exposing (succeed)
import Route exposing (Route)
import Styles.Colors as Colors
import Styles.Text as Text
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgA


container : List (Html Msg) -> Html Msg
container stuff =
    Html.div [] (Text.body :: stuff)


nav : List ( String, Route ) -> Html Msg
nav routes =
    Html.nav
        []
        (List.map (\( name, route ) -> navLink name route) routes)


navLink : String -> Route -> Html Msg
navLink caption route =
    link route [] [ Html.text caption ]


{-| TODO: flip the first two arguments so this is easier to use
-}
link : Route -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
link route base children =
    let
        destination =
            case route of
                Route.Internal { html } ->
                    [ Attributes.href html
                    , Events.onWithOptions "click"
                        -- TODO: this is blocking cmd-click
                        { stopPropagation = True
                        , preventDefault = True
                        }
                        (succeed <| GoTo route)
                    ]

                Route.External html ->
                    [ Attributes.href html ]
    in
    Html.a (destination ++ base) children


linkGhostButton : Route -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
linkGhostButton route base children =
    link
        route
        (css
            [ Css.padding2 (Css.px 10) (Css.px 30)
            , Css.color Colors.white
            , Css.border3 (Css.px 1) Css.solid Colors.white
            , Css.borderRadius (Css.px 4)
            , Css.hover [ Css.textDecoration Css.none ]
            , Css.backgroundColor Colors.ghostlyWhite
            ]
            :: base
        )
        children


spacer : Float -> Html msg
spacer scale =
    Html.div [ css [ Css.height <| Text.scale scale ] ] []


elmLogo : Float -> List (Attribute msg) -> Html msg
elmLogo scale rest =
    Html.div
        (css
            [ Css.width <| Text.scale scale
            , Css.height <| Text.scale scale
            ]
            :: rest
        )
        [ Svg.svg
            [ SvgA.viewBox "0 0 324 324"
            , SvgA.preserveAspectRatio "xMidYMid meet"
            ]
            [ Svg.g
                [ SvgA.stroke "none"
                , SvgA.strokeWidth "1"
                , SvgA.fill "#FDFDFD"
                , SvgA.fillRule "nonzero"
                ]
                [ Svg.polygon [ SvgA.points "162.000501 153 232 83 92 83" ] []
                , Svg.polygon [ SvgA.points "9 0 79.264979 70 232 70 161.734023 0" ] []
                , Svg.polygon [ SvgA.points "324 144 324 0 180 0" ] []
                , Svg.polygon [ SvgA.points "153 161.998999 0 9 0 315" ] []
                , Svg.polygon [ SvgA.points "256 246.999498 324 315 324 179" ] []
                , Svg.polygon [ SvgA.points "161.999499 171 9 324 315 324" ] []
                , Svg.rect
                    [ SvgA.transform "translate(247.311293, 161.311293) rotate(45.000000) translate(-247.311293, -161.311293)"
                    , SvgA.x "193.473809"
                    , SvgA.y "107.228311"
                    , SvgA.width "108"
                    , SvgA.height "108"
                    ]
                    []
                ]
            ]
        ]
