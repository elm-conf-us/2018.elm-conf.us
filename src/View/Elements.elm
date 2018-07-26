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
        , youtube
        )

import App exposing (Msg(..))
import Css exposing ((|*|), (|-|))
import Css.Foreign as Foreign
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes exposing (css, property)
import Json.Encode as Encode
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


sharedSectionStyles : Attribute msg
sharedSectionStyles =
    css
        [ Foreign.adjacentSiblings
            [ Foreign.section [ Css.marginTop (Text.scale 4) ]
            ]
        ]


section : List (Html Msg) -> Html Msg
section contents =
    Html.section [ sharedSectionStyles ] contents


type alias Image =
    -- TODO srcset sizes stuff for retina displays
    { src : String
    , alt : String
    , round : Bool
    }


sectionWithImage : Image -> List (Html Msg) -> Html Msg
sectionWithImage image contents =
    Html.section
        [ sharedSectionStyles
        , css
            [ Css.maxWidth Text.fullSize
            , Css.displayFlex
            , Css.flexDirection Css.row
            , Css.justifyContent Css.spaceAround
            , Css.marginLeft (Text.narrowColumnSize |*| Css.rem -1)
            , Breakpoints.belowFullSize
                [ Css.flexDirection Css.column
                , Css.marginLeft Css.zero
                ]
            ]
        ]
        [ Html.div
            [ css
                [ Css.width Text.narrowColumnSize
                , Css.maxHeight Text.narrowColumnSize
                , Breakpoints.belowFullSize [ Css.margin4 Css.zero Css.auto (Text.scale 1) Css.auto ]
                ]
            ]
            [ Html.img
                [ css
                    [ Css.width (Text.scale 8.25)
                    , Breakpoints.belowFullSize [ Css.width (Css.pct 100) ]
                    ]
                , if image.round then
                    css [ Css.borderRadius (Css.pct 100) ]
                  else
                    property "" Encode.null
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


youtube : String -> Html msg
youtube id =
    Html.div
        [ css
            [ Css.position Css.relative
            , Css.paddingBottom (Css.pct 56.25)
            , Css.height Css.zero
            , Css.overflow Css.hidden
            , Css.maxWidth (Css.pct 100)
            ]
        ]
        [ Html.iframe
            [ css
                [ Css.position Css.absolute
                , Css.top Css.zero
                , Css.left Css.zero
                , Css.width (Css.pct 100)
                , Css.height (Css.pct 100)
                ]
            , Attributes.src ("https://www.youtube-nocookie.com/embed/" ++ id)
            , Attributes.property "frameBorder" (Encode.int 0)
            , Attributes.property "allow" (Encode.string "autoplay; encrypted-media")
            , Attributes.attribute "allowfullscreen" ""
            ]
            []
        ]
