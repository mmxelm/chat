module MessageEncoder exposing (..)

import Types exposing (ClientEvent(..))


encodeEvent : ClientEvent -> String
encodeEvent event =
    case event of
        ListChannels ->
            "{\"event\": \"LISTCHAN\"}"

        ListChannelMembers channel ->
            "{\"event\": \"LISTMEMBERS\", \"target\":\"" ++ channel ++ "\"}"

        SetNick nick ->
            "{\"event\": \"NICK\", \"data\":\"" ++ nick ++ "\"}"

        SendChannelMessage m ->
            "{\"event\": \"MSG\", \"target\":\"" ++ m.target ++ "\", \"data\":\"" ++ m.message ++ "\"}"

        SendPrivateMessage m ->
            "{\"event\": \"PM\", \"target\":\"" ++ m.target ++ "\", \"data\":\"" ++ m.message ++ "\"}"

        JoinChannel channel ->
            "{\"event\": \"JOIN\", \"target\":\"" ++ channel ++ "\"}"

        LeaveChannel channel ->
            "{\"event\": \"PART\", \"target\":\"" ++ channel ++ "\"}"
