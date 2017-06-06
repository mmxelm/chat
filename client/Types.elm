module Types exposing (..)


type alias PrivateMessageModel =
    { event : String, from : String, message : String }


type alias MessageModel =
    { event : String, from : String, target : String, message : String }


type ServerEvent
    = PrivateMessage PrivateMessageModel
    | Message MessageModel
    | ChannelMessage
    | UnknownEvent
    | MalformedJson


type Msg
    = NewMessage String
    | Send
