module Elements.Content exposing (root)

import Css exposing (..)
import Dict exposing (Dict)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attributes
import Json.Decode
import Page.Content exposing (Content(Element, Text), Root(Root))


root : Root -> Html msg
root (Root children) =
    Html.main_ [] (List.map content children)


content : Content -> Html msg
content node =
    case node of
        Element tag props children ->
            Html.node tag (properties props) (List.map content children)

        Text stuff ->
            Html.text stuff


properties : Dict String Json.Decode.Value -> List (Attribute msg)
properties =
    Dict.foldr (\k v acc -> Attributes.property k v :: acc) []
