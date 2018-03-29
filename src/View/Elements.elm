module View.Elements
    exposing
        ( container
        , header
        )

import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes
import Route exposing (Route)


container : List (Html msg) -> Html msg
container =
    Html.div [ Attributes.css [] ]


header : List ( String, Route ) -> Html msg
header routes =
    Html.nav
        []
        (List.map (\( name, route ) -> headerLink name route) routes)


headerLink : String -> Route -> Html msg
headerLink caption route =
    link caption route []


link : String -> Route -> List (Attribute msg) -> Html msg
link caption route base =
    let
        destination =
            case route of
                Route.Internal { html } ->
                    [ Attributes.href html ]

                Route.External html ->
                    [ Attributes.href html ]
    in
    Html.a (destination ++ base) [ Html.text caption ]
