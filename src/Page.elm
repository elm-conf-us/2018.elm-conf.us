module Page exposing (Content(..), FrontMatter, Page, decoder)

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
                (field "image" (maybe string))
                (field "video" (maybe string))

        body : String -> Decoder Page
        body type_ =
            case type_ of
                "page" ->
                    map2 Page
                        (field "frontMatter" frontMatter)
                        (map Single <| field "content" Content.decoder)

                "section" ->
                    map2 Page
                        (field "frontMatter" frontMatter)
                        (map Section <| field "pages" <| list decoder)

                _ ->
                    fail <| "I don't know how to decode a '" ++ type_ ++ "'"
    in
    field "type" string |> andThen body
