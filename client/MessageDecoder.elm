module MessageDecoder exposing (parseEvent)

import Types exposing (..)
import Json.Decode exposing (..)
import Json.Decode exposing (int, string, float, bool, list, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, hardcoded)


-- Convert string with json to message
-- {event: 'PM',source:'Nick', data: 'Hey'}


parsePm : String -> ServerEvent
parsePm message =
    let
        pmDecoder : Decoder PrivateMessageModel
        pmDecoder =
            decode PrivateMessageModel
                |> required "event" string
                |> required "source" string
                |> required "data" string

        result =
            decodeString pmDecoder message
    in
        case result of
            Ok model ->
                PrivateMessage model

            Err msg ->
                let
                    x =
                        Debug.log "pm" msg
                in
                    MalformedJson


parseMsg : String -> ServerEvent
parseMsg message =
    let
        decoder : Decoder MessageModel
        decoder =
            decode MessageModel
                |> required "event" string
                |> required "source" string
                |> required "target" string
                |> required "data" string

        result =
            decodeString decoder message
    in
        case result of
            Ok model ->
                Message model

            Err msg ->
                let
                    x =
                        Debug.log "pm" msg
                in
                    MalformedJson


parseEvent : String -> ServerEvent
parseEvent message =
    let
        event =
            decodeString (field "event" string) message
    in
        case event of
            Ok value ->
                case value of
                    "PM" ->
                        parsePm message

                    "MSG" ->
                        parseMsg message

                    _ ->
                        UnknownEvent

            Err error ->
                let
                    f =
                        Debug.log "event" error
                in
                    UnknownEvent
