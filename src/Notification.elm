port module Notification exposing (new)

import Json.Encode as Encode exposing (Value)


new : String -> Cmd msg
new title =
    newNotification (Encode.string title)



-- PORTS


port newNotification : Value -> Cmd msg
