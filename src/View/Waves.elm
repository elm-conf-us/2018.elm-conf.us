module View.Waves exposing (waves)

import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as HAttributes
import Svg.Styled as Svg exposing (Attribute, Svg)
import Svg.Styled.Attributes as Attributes


waves : String -> Html msg
waves color =
    let
        height =
            100

        waves =
            [ ( "little", 900, 100 )
            , ( "medium", 1100, 300 )
            , ( "big", 1300, 500 )
            ]
    in
    Svg.svg
        [ HAttributes.style
            [ ( "width", "100%" )
            , ( "height", toString height ++ "px" )
            ]
        ]
        [ Svg.defs [] <|
            List.map
                (\( name, wavelength, offset ) ->
                    Svg.pattern
                        [ Attributes.id name
                        , Attributes.width <| toString wavelength
                        , Attributes.height <| toString height
                        , Attributes.patternUnits "userSpaceOnUse"
                        , Attributes.x <| toString offset
                        ]
                        [ waveSegment color wavelength height ]
                )
                waves
        , Svg.g [] <|
            List.map
                (\( name, wavelength, _ ) ->
                    Svg.rect
                        [ Attributes.fill <| "url(#" ++ name ++ ")"
                        , Attributes.width "100%"
                        , Attributes.height "100%"
                        ]
                        []
                )
                waves
        ]


waveSegment : String -> Float -> Float -> Svg msg
waveSegment fill width height =
    let
        m =
            0.5122866232565925

        curve =
            String.join " "
                [ -- move to the right place
                  "M"
                , "0"
                , toString <| 0.75 * height

                -- going up!
                , "c"
                , toString <| 0.5 * width * m
                , "0"
                , toString <| 0.5 * width * (1 - m)
                , toString <| -0.75 * height
                , toString <| 0.5 * width
                , toString <| -0.75 * height

                -- and back down
                , "s"
                , toString <| 0.5 * width * (1 - m)
                , toString <| 0.75 * height
                , toString <| 0.5 * width
                , toString <| 0.75 * height

                -- line to the bottom
                , "L"
                , toString width
                , toString height

                -- complete the line at the right
                , "L"
                , "0"
                , toString height
                ]
    in
    Svg.path
        [ Attributes.d curve
        , Attributes.fill fill
        , Attributes.stroke "none"
        , Attributes.width <| toString width
        , Attributes.height <| toString height
        ]
        []
