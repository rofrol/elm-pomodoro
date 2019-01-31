module Main exposing (main)

import Browser
import Html
import Task
import Time exposing (Posix)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- Model


type alias Model =
    { posix : Posix
    , zone : Time.Zone
    , running : Bool
    }



-- Msg


type Msg
    = Tick Posix
    | Zone Time.Zone
    | Running Bool



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0) Time.utc True, Task.perform Zone Time.here )



-- Update


update msg model =
    case msg of
        Tick newPosix ->
            ( { model | posix = newPosix }, Cmd.none )

        Zone zone ->
            ( { model | zone = zone }, Cmd.none )

        Running state ->
            ( { model | running = state }, Cmd.none )



-- Subscriptions


subscriptions model =
    if model.running then
        Time.every 1000 Tick

    else
        Sub.none



-- View


view model =
    Html.text <|
        formatTime model.zone model.posix


formatTime zone posix =
    (String.padLeft 2 '0' <| String.fromInt <| Time.toHour zone posix)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toMinute zone posix)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toSecond zone posix)
