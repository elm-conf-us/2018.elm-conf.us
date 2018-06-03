module View.Elements
    exposing
        ( Image
        , container
        , elmLogo
        , link
        , linkGhostButton
        , nav
        , section
        , sectionWithImage
        , spacer
        )

import App exposing (Msg(..))
import Css exposing ((|*|), (|-|))
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (css)
import Route exposing (Route)
import Styles.Breakpoints as Breakpoints
import Styles.Elements as Elements
import Styles.Text as Text
import Svg.Styled as Svg
import Svg.Styled.Attributes as SvgA
import View.Elements.Events exposing (onClickPreventDefaultForLinkWithHref)


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
                    , onClickPreventDefaultForLinkWithHref (GoTo route)
                    ]

                Route.External html ->
                    [ Attributes.href html ]
    in
    Html.a (destination ++ base) children


linkGhostButton : Route -> List (Attribute Msg) -> List (Html Msg) -> Html Msg
linkGhostButton route base children =
    link
        route
        (Elements.ghostButton :: base)
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


section : List (Html Msg) -> Html Msg
section contents =
    Html.section [] contents


type alias Image =
    -- TODO srcset sizes stuff for retina displays
    { src : String
    , alt : String
    }


sectionWithImage : Image -> List (Html Msg) -> Html Msg
sectionWithImage image contents =
    let
        leftColumnSize =
            Text.fullSize |-| Text.wideColumnSize
    in
    Html.section
        [ css
            [ Css.maxWidth Text.fullSize
            , Css.displayFlex
            , Css.flexDirection Css.row
            , Css.marginLeft (leftColumnSize |*| Css.px -1)
            , Breakpoints.belowFullSize
                [ Css.flexDirection Css.column
                , Css.marginLeft Css.zero
                ]
            ]
        ]
        [ Html.div
            [ css
                [ -- TODO: make these not magic values
                  Css.width (leftColumnSize |-| Css.px 25)
                , Css.height (leftColumnSize |-| Css.px 25)
                , Css.marginRight (Text.scale 2)
                , Breakpoints.belowFullSize [ Css.margin4 Css.zero Css.auto (Text.scale 2) Css.auto ]
                ]
            ]
            [ Html.img
                [ css
                    [ Css.width (Css.pct 100)
                    , Css.height Css.auto
                    , Css.borderRadius (Css.pct 100)
                    ]
                , Attributes.src image.src
                , Attributes.alt image.alt
                ]
                []
            ]
        , Html.div
            [ css
                [ Css.width Text.wideColumnSize
                , Breakpoints.belowFullSize [ Css.width Css.auto ]
                ]
            ]
            contents
        ]
