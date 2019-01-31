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
    , secondsRemaining : Int
    }



-- Msg


type Msg
    = Tick Posix
    | Zone Time.Zone
    | Running Bool



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model (Time.millisToPosix 0) Time.utc True (25 * 60), Task.perform Zone Time.here )



-- Update


update msg model =
    case msg of
        Tick newPosix ->
            ( { model | posix = newPosix, secondsRemaining = model.secondsRemaining - 1 }, Cmd.none )

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
    Html.div []
        [ Html.div []
            [ Html.text <|
                formatTime model.zone model.posix
            ]
        , Html.text <| formatSeconds model.secondsRemaining
        ]


formatTime zone posix =
    (String.padLeft 2 '0' <| String.fromInt <| Time.toHour zone posix)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toMinute zone posix)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toSecond zone posix)


formatSeconds seconds =
    (String.padLeft 2 '0' <| String.fromInt <| seconds // 60)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| remainderBy 60 seconds)
