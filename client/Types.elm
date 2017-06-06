module Types exposing (..)


type alias PrivateMessageModel =
    { from : String, message : String }


type alias MessageModel =
    { from : String, target : String, message : String }


type alias ChannelsModel =
    { channels : List String }


type alias MembersModel =
    { target : String, data : List String }


type alias SendMessageModel =
    { target : String, message : String }


type ServerEvent
    = PrivateMessage PrivateMessageModel
    | Message MessageModel
    | Channels ChannelsModel
    | Members MembersModel
    | UnknownEvent
    | MalformedJson


type ClientEvent
    = ListChannels
    | ListChannelMembers String
    | SetNick String
    | SendChannelMessage SendMessageModel
    | SendPrivateMessage SendMessageModel
    | JoinChannel String
    | LeaveChannel String


type Msg
    = NewMessage String
    | Send
