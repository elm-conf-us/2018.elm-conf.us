module Page exposing (Page, decoder)

import Json.Decode exposing (..)


type alias Page =
    { title : String
    , contents : Value
    }


decoder : Decoder Page
decoder =
    map2 Page
        (at [ "frontMatter", "title" ] string)
        (field "content" value)
