module MessageDecoder exposing (parseEvent)

import Types exposing (..)
import Json.Decode exposing (..)
import Json.Decode exposing (int, string, float, bool, list, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, hardcoded)


parsePm : String -> ServerEvent
parsePm message =
    let
        pmDecoder : Decoder PrivateMessageModel
        pmDecoder =
            decode PrivateMessageModel
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


parseChannels : String -> ServerEvent
parseChannels message =
    let
        decoder : Decoder ChannelsModel
        decoder =
            decode ChannelsModel
                |> required "data" (list string)

        result =
            decodeString decoder message
    in
        case result of
            Ok model ->
                Channels model

            Err msg ->
                let
                    x =
                        Debug.log "pm" msg
                in
                    MalformedJson


parseMembers : String -> ServerEvent
parseMembers message =
    let
        decoder : Decoder MembersModel
        decoder =
            decode MembersModel
                |> required "target" string
                |> required "data" (list string)

        result =
            decodeString decoder message
    in
        case result of
            Ok model ->
                Members model

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

                    "CHANNELS" ->
                        parseChannels message

                    "MEMBERS" ->
                        parseMembers message

                    _ ->
                        UnknownEvent

            Err error ->
                UnknownEvent
