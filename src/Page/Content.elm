module Page.Content
    exposing
        ( Alignment(..)
        , Content(..)
        , EmphasisAmount(..)
        , Level(..)
        , Ordering(..)
        , Root(..)
        , decoder
        )

import Json.Decode as Decode exposing (..)


type Root
    = Root (List Content)


type Content
    = Heading Level (List Content)
    | SemanticBreak
    | ListParent Ordering (List Content)
    | ListItem (List Content)
    | Paragraph (List Content)
    | Link String (List Content)
    | Text String
    | Emphasized EmphasisAmount (List Content)
    | Code (List Content)
    | Table (List Content)
    | TableRow (List Content)
    | TableHead (List Content)
    | TableHeadCell Alignment (List Content)
    | TableBody (List Content)
    | TableCell Alignment (List Content)


type Level
    = First
    | Second
    | Third


type Ordering
    = Ordered
    | Unordered


type EmphasisAmount
    = Regular
    | Strong


type Alignment
    = Unset
    | Left
    | Right
    | Center


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
                    field "tagName" string |> andThen element

                -- map3 Element
                --     (field "tagName" string)
                --     (field "properties" value)
                --     (field "children" <| list content)
                "text" ->
                    map Text (field "value" string)

                _ ->
                    fail ("I don't know how to decode a '" ++ type_ ++ "' for content")


element : String -> Decoder Content
element tag =
    let
        children =
            field "children" (list content)
    in
    case tag of
        "h1" ->
            map (Heading First) children

        "h2" ->
            map (Heading Second) children

        "h3" ->
            map (Heading Third) children

        "hr" ->
            succeed SemanticBreak

        "ul" ->
            map (ListParent Unordered) children

        "ol" ->
            map (ListParent Ordered) children

        "li" ->
            map ListItem children

        "p" ->
            map Paragraph children

        "a" ->
            map2 Link (at [ "properties", "href" ] string) children

        "em" ->
            map (Emphasized Regular) children

        "strong" ->
            map (Emphasized Strong) children

        "code" ->
            map Code children

        "table" ->
            map Table children

        "thead" ->
            map TableHead children

        "tbody" ->
            map TableBody children

        "tr" ->
            map TableRow children

        "td" ->
            map2 TableCell
                (at [ "properties", "align" ] alignment)
                children

        "th" ->
            map2 TableHeadCell
                (at [ "properties", "align" ] alignment)
                children

        _ ->
            fail ("The '" ++ tag ++ "' tag is not allowed!")


taggedType : (String -> Decoder a) -> Decoder a
taggedType fn =
    field "type" string |> andThen fn


alignment : Decoder Alignment
alignment =
    oneOf
        [ string
            |> andThen
                (\align ->
                    case align of
                        "left" ->
                            succeed Left

                        "center" ->
                            succeed Center

                        "right" ->
                            succeed Right

                        _ ->
                            fail ("I don't know how to interpret a '" ++ align ++ "' alignment.")
                )
        , null Unset
        ]
