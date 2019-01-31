module Main exposing (main)

import Browser
import Html
import Html.Events as Events
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
    { zone : Time.Zone
    , running : Bool
    , secondsRemaining : Int
    }



-- Msg


type Msg
    = Tick Posix
    | Zone Time.Zone
    | Running Bool
    | Reset



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc False (25 * 60), Task.perform Zone Time.here )



-- Update


update msg model =
    case msg of
        Tick _ ->
            ( { model | secondsRemaining = model.secondsRemaining - 1 }, Cmd.none )

        Zone zone ->
            ( { model | zone = zone }, Cmd.none )

        Running state ->
            ( { model | running = state }, Cmd.none )

        Reset ->
            ( { model | secondsRemaining = 25 * 60, running = False }, Cmd.none )



-- Subscriptions


subscriptions model =
    if model.running then
        Time.every 1000 Tick

    else
        Sub.none



-- View


view model =
    Html.div []
        [ Html.text <| formatSeconds model.secondsRemaining
        , Html.div []
            [ Html.button [ Events.onClick (Running True) ] [ Html.text "Start" ]
            , Html.button [ Events.onClick (Running False) ] [ Html.text "Stop" ]
            , Html.button [ Events.onClick Reset ] [ Html.text "Reset" ]
            ]
        ]


formatSeconds seconds =
    (String.padLeft 2 '0' <| String.fromInt <| seconds // 60)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| remainderBy 60 seconds)
