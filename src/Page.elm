module Page exposing (Page, decoder)

import Json.Decode exposing (..)
import Page.Content as Content exposing (Content)


type alias Page =
    { title : String
    , content : Content
    }


decoder : Decoder Page
decoder =
    map2 Page
        (at [ "frontMatter", "title" ] string)
        (field "content" Content.decoder)
