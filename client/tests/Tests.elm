module Tests exposing (..)

import Test exposing (..)
import Expect
import MessageDecoder exposing (parseEvent)
import MessageEncoder exposing (encodeEvent)
import Types exposing (..)


decoder : Test
decoder =
    describe "decoder"
        [ test "Pm" <|
            \() ->
                Expect.equal (parseEvent "{\"event\": \"PM\",\"source\":\"foo\", \"data\": \"Hey\"}")
                    (PrivateMessage (PrivateMessageModel "foo" "Hey"))
        , test "Msg" <|
            \() ->
                Expect.equal (parseEvent "{\"event\": \"MSG\",\"source\":\"foo\", \"target\":\"#general\", \"data\": \"Hey\"}")
                    (Message (MessageModel "foo" "#general" "Hey"))
        , test "Channels" <|
            \() ->
                Expect.equal (parseEvent "{\"event\":\"CHANNELS\",\"data\":[\"#a\",\"#b\"]}")
                    (Channels (ChannelsModel [ "#a", "#b" ]))
        , test "MEMBERS" <|
            \() ->
                Expect.equal (parseEvent "{\"event\":\"MEMBERS\", \"target\":\"#general\", \"data\":[\"foo\",\"bar\"]}")
                    (Members (MembersModel "#general" [ "foo", "bar" ]))
        , test "Unknown" <|
            \() -> Expect.equal (parseEvent "") UnknownEvent
        ]


encoder : Test
encoder =
    describe "encoder"
        [ test "ListChannels" <|
            \() ->
                Expect.equal (encodeEvent ListChannels)
                    "{\"event\": \"LISTCHAN\"}"
        , test "ListChannelMembers" <|
            \() ->
                Expect.equal (encodeEvent (ListChannelMembers "#general"))
                    "{\"event\": \"LISTMEMBERS\", \"target\":\"#general\"}"
        , test "SetNick" <|
            \() ->
                Expect.equal (encodeEvent (SetNick "foo"))
                    "{\"event\": \"NICK\", \"data\":\"foo\"}"
        , test "SendChannelMessage" <|
            \() ->
                Expect.equal (encodeEvent (SendChannelMessage (SendMessageModel "#general" "some message")))
                    "{\"event\": \"MSG\", \"target\":\"#general\", \"data\":\"some message\"}"
        , test "SendPrivateMessage" <|
            \() ->
                Expect.equal (encodeEvent (SendPrivateMessage (SendMessageModel "foo" "some message")))
                    "{\"event\": \"PM\", \"target\":\"foo\", \"data\":\"some message\"}"
        , test "JoinChannel" <|
            \() ->
                Expect.equal (encodeEvent (JoinChannel "#misc"))
                    "{\"event\": \"JOIN\", \"target\":\"#misc\"}"
        , test "LeaveChannel" <|
            \() ->
                Expect.equal (encodeEvent (LeaveChannel "#misc"))
                    "{\"event\": \"PART\", \"target\":\"#misc\"}"
        ]


all : Test
all =
    describe "Test Suite"
        [ decoder
        , encoder
        ]
