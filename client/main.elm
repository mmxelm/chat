module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import WebSocket
import Types exposing (..)
import MessageDecoder exposing (parseEvent)
import MessageEncoder exposing (encodeEvent)


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Send event ->
            ( "", WebSocket.send "ws://localhost:8080" (encodeEvent event) )

        NewMessage str ->
            let
                _ =
                    Debug.log "msg" str

                event =
                    parseEvent str
            in
                ( str, Cmd.none )


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen "ws://localhost:8080" NewMessage


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (Send ListChannels) ] [ text "Send" ]
        ]
