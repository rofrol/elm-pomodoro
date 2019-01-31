module Main exposing (main)

import Browser
import Html
import Html.Attributes as Attrs
import Html.Events as Events
import Task
import Time exposing (Posix)


main =
    Browser.document
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
    , period : Period
    }


type Period
    = Pomodoro
    | LongBreak
    | ShortBreak



-- Msg


type Msg
    = Tick Posix
    | Zone Time.Zone
    | Running Bool
    | Reset
    | SwitchPeriod Period



-- Init


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc False (periodToSeconds Pomodoro) Pomodoro, Task.perform Zone Time.here )



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
            ( { model | secondsRemaining = periodToSeconds Pomodoro, running = False }, Cmd.none )

        SwitchPeriod period ->
            ( { model | period = period, running = True, secondsRemaining = periodToSeconds period }, Cmd.none )


periodToSeconds period =
    case period of
        Pomodoro ->
            25 * 60

        ShortBreak ->
            5 * 60

        LongBreak ->
            10 * 60



-- Subscriptions


subscriptions model =
    if model.running then
        Time.every 1000 Tick

    else
        Sub.none



-- View


view model =
    Browser.Document
        ("(" ++ formatSeconds model.secondsRemaining ++ ")")
        [ Html.div
            []
            [ Html.div []
                [ Html.label []
                    [ Html.input
                        [ Attrs.type_ "radio"
                        , Attrs.checked (model.period == Pomodoro)
                        , Events.onClick (SwitchPeriod Pomodoro)
                        ]
                        []
                    , Html.text "Pomodoro"
                    ]
                , Html.label []
                    [ Html.input
                        [ Attrs.type_ "radio"
                        , Attrs.checked (model.period == ShortBreak)
                        , Events.onClick (SwitchPeriod ShortBreak)
                        ]
                        []
                    , Html.text "Short Break"
                    ]
                , Html.label []
                    [ Html.input
                        [ Attrs.type_ "radio"
                        , Attrs.checked (model.period == LongBreak)
                        , Events.onClick (SwitchPeriod LongBreak)
                        ]
                        []
                    , Html.text "Long Break"
                    ]
                ]
            , Html.text <| formatSeconds model.secondsRemaining
            , Html.div []
                [ Html.button [ Events.onClick (Running True), Attrs.disabled model.running ] [ Html.text "Start" ]
                , Html.button [ Events.onClick (Running False), Attrs.disabled (not model.running) ] [ Html.text "Stop" ]
                , Html.button [ Events.onClick Reset ] [ Html.text "Reset" ]
                ]
            ]
        ]


formatSeconds seconds =
    (String.padLeft 2 '0' <| String.fromInt <| seconds // 60)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| remainderBy 60 seconds)
