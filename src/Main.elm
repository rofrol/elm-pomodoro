module Main exposing (main)

import Browser
import Html


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    Int


init : () -> ( (), Cmd msg )
init _ =
    ( (), Cmd.none )


update msg model =
    ( model, Cmd.none )


subscriptions model =
    Sub.none


view model =
    Html.text
        "Hello"
