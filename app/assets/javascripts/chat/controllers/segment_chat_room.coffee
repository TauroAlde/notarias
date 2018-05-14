class @SegmentChatRoom extends @ChatRoomBase
  

  constructor: (data, chat, pool) ->
    @template = window.JST["chat/templates/segment_messages_pool_item"]
    @messageClass = window.SegmentMessage
    @chatRoomModelClass = window.Segment
    super(data, chat, pool)

  chatRoomPath: ->
    "/segment_messages/#{ @model.id }"

  fetchId: ->
    base_string = super()
    if @params
      base_string += "?segment_id=#{@params.id}"
    base_string