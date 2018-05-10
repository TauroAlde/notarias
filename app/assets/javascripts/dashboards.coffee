# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class SegmentMessageResume
  constructor: (resumeMessageEl) ->
    @el = $(resumeMessageEl)
    @bindClickLoadChat()

  bindClickLoadChat: ->
    window.previous = "home"
    @el.click (e) =>
      e.preventDefault()
      e.stopPropagation()
      $.getScript "/segment_messages/#{ @el.attr("data-segment-message-id") }"


class Chat
  constructor: () ->
    @el = $("#chat-pool")
    @bindClose()
    @bindOpen()
    @loadMessagesFullList()

  reload: ->
    window.previous = undefined
    @loadMessagesFullList()

  hide: ->
    @el.removeClass("show")
    @el.addClass("hide")
    @el.css("z-index", -1000)

  show: ->
    @el.removeClass("hide")
    @el.addClass("show")
    @el.css("z-index", 9999)
    @loadMessagesFullList()

  bindClose: ->
    @el.find(".close").click (e)=>
      if window.previous == "home"
        @reload()
      else
        @hide()

  isShown: ->
    @el.hasClass("show")

  isHidden: ->
    @el.hasClass("hide")

  bindOpen: ->
    $("#open-messages-button").click (e) =>
      if @isHidden()
        @show()
    
    $("#open-messages-button-mobile").click (e) =>
      if @isHidden()
        @show()

  loadMessagesFullList: ->
    $.getScript("/segment_messages", () => @buildSegmentMessageResumes() )

  buildSegmentMessageResumes: ->
    resumes = []
    @el.find(".segment-message-resume-list-item").each (i)->
      resumes.push(new SegmentMessageResume(@))
    @resumes = resumes





$ ->
  $(window).click (e) ->
    catchLeftClick(e)

  catchLeftClick = (event) ->
    if event.target == $('#open-hide')[0] or $('#open-hide').find(event.target).length
      $('#left-sidebar').toggleClass 'show-sidebar'
      #event.preventDefault()
    else
      $('#left-sidebar').removeClass 'show-sidebar'
    return

  catchRightClick = (event) ->
    if event.target == $('#right-sidebar-switch')[0] or $('#right-sidebar-switch').find(event.target).length
      #event.preventDefault()
      $('#right-sidebar').toggleClass 'show-right-sidebar'
    else if event.target == $('#close-sidebar')[0]
      #event.preventDefault()
      $('#right-sidebar').removeClass 'show-right-sidebar'
    else if event.target == $('#right-sidebar')[0] or $('#right-sidebar').find(event.target).length
      $('#right-sidebar').addClass 'show-right-sidebar'
    else
      $('#right-sidebar').removeClass 'show-right-sidebar'
    return

  window.chat = new Chat