module Page.Content exposing (Content(..), Root(..), decoder)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (..)
import Set


type Root
    = Root (List Content)


type Content
    = Element String (Dict String Decode.Value) (List Content)
    | Text String


decoder : Decoder Root
decoder =
    taggedType <|
        \type_ ->
            case type_ of
                "root" ->
                    map Root (field "children" <| list content)

                _ ->
                    fail ("I don't know how to decode a '" ++ type_ ++ "' for root")


content : Decoder Content
content =
    taggedType <|
        \type_ ->
            case type_ of
                "element" ->
                    map3 Element
                        (field "tagName" string)
                        (field "properties" properties)
                        (field "children" <| list content)

                "text" ->
                    map Text (field "value" string)

                _ ->
                    fail ("I don't know how to decode a '" ++ type_ ++ "' for content")


properties : Decoder (Dict String Decode.Value)
properties =
    let
        allowedProperties =
            Set.fromList [ "href" ]
    in
    dict value
        |> map (Dict.partition <| \key _ -> Set.member key allowedProperties)
        |> andThen
            (\( good, bad ) ->
                if Dict.isEmpty bad then
                    succeed good
                else
                    fail <| "Some properties aren't allowed: " ++ toString (Dict.keys bad)
            )


taggedType : (String -> Decoder a) -> Decoder a
taggedType fn =
    field "type" string |> andThen fn
