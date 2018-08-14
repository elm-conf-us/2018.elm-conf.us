module Page
    exposing
        ( Content(..)
        , FrontMatter
        , Page
        , decoder
        , hasImages
        , mapSource
        )

import Json.Decode exposing (..)
import Page.Content as Content


type alias Page =
    { frontMatter : FrontMatter
    , content : Content
    }


type alias HeroImage =
    { source : String
    , round : Bool
    }


type alias FrontMatter =
    { title : String
    , source : Maybe String
    , image : Maybe HeroImage
    , time : Maybe String
    }


type Content
    = Single Content.Root
    | Section (List Page)


decoder : Decoder Page
decoder =
    let
        frontMatter : Decoder FrontMatter
        frontMatter =
            map4 FrontMatter
                (field "title" string)
                (maybe (field "source" string))
                (maybe (field "image" heroImage))
                (maybe (field "time" string))

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


heroImage : Decoder HeroImage
heroImage =
    oneOf
        [ map (\src -> HeroImage src True) string
        , map2 HeroImage
            (field "source" string)
            (field "round" bool)
        ]


hasImages : Page -> Bool
hasImages ({ frontMatter } as page) =
    case page.content of
        Single _ ->
            frontMatter.image /= Nothing

        Section subPages ->
            frontMatter.image /= Nothing || List.any hasImages subPages


mapSource : (String -> a) -> Page -> Maybe a
mapSource fn { frontMatter } =
    Maybe.map fn frontMatter.source
