# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $(window).click (e) ->
    if e.target == $('#open-hide')[0] or $('#open-hide').find(e.target).length
      $('#left-sidebar').toggleClass 'show-sidebar'
      e.preventDefault()
    else if e.target == $('#left-sidebar-content')[0] or $('#left-sidebar-content').find(e.target).length
      $('#left-sidebar').addClass 'show-sidebar'
    else
      $('#left-sidebar').removeClass 'show-sidebar'
    return
