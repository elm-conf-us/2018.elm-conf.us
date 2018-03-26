module Page.Content exposing (Content, decoder)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)


type
    Content
    -- TODO: separate to contentRoot or List Content or something
    = Root (List Content)
    | Element String (Dict String Decode.Value) (List Content)
    | Text String


decoder : Decoder Content
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\type_ ->
                case type_ of
                    "root" ->
                        Decode.map Root
                            (Decode.field "children" <| Decode.list decoder)

                    "element" ->
                        Decode.map3 Element
                            (Decode.field "tagName" Decode.string)
                            (Decode.field "properties" <| Decode.dict Decode.value)
                            (Decode.field "children" <| Decode.list decoder)

                    "text" ->
                        Decode.map Text
                            (Decode.field "value" Decode.string)

                    _ ->
                        Decode.fail ("I don't know how to decode a '" ++ type_ ++ "'")
            )
