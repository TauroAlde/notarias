class @SegmentMessage extends window.Message
  constructor: (data, chat, pool, chatRoom) ->
    @template = window.JST["chat/templates/segment_message"]
    super(data, chat, pool, chatRoom)