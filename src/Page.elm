module Page
    exposing
        ( Content(..)
        , FrontMatter
        , Page
        , decoder
        , hasImages
        )

import Json.Decode exposing (..)
import Page.Content as Content


type alias Page =
    { frontMatter : FrontMatter
    , content : Content
    }


type alias FrontMatter =
    { title : String
    , image : Maybe String
    , video : Maybe String
    }


type Content
    = Single Content.Root
    | Section (List Page)


decoder : Decoder Page
decoder =
    let
        frontMatter : Decoder FrontMatter
        frontMatter =
            map3 FrontMatter
                (field "title" string)
                (maybe (field "image" string))
                (maybe (field "video" string))

        body : String -> Decoder Content
        body type_ =
            case type_ of
                "page" ->
                    map Single (field "content" Content.decoder)

                "section" ->
                    map Section (field "pages" (list decoder))

                _ ->
                    fail <| "I don't know how to decode a '" ++ type_ ++ "'"
    in
    map2 Page
        (field "frontMatter" frontMatter)
        (field "type" string |> andThen body)


hasImages : Page -> Bool
hasImages ({ frontMatter } as page) =
    case page.content of
        Single _ ->
            frontMatter.image /= Nothing

        Section subPages ->
            frontMatter.image /= Nothing || List.any hasImages subPages
