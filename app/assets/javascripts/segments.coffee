# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#class JstreeNode
#  $el = ->
#    
#
#
#redrawNode = (el) ->
#  node = $(el)
#
#  anchor = node.children(".jstree-anchor")
#  badge_class = null
#
#  if node.attr("data-users-count") == "0"
#    badge_class = "secondary"
#  else
#    badge_class = "success"
#
#  html = "<span class=\"badge badge-pill badge-#{badge_class} ml-2\"><i class=\"fa fa-users mr-1\"></i>#{node.attr("data-users-count")} </span>"
#  html += "<span class=\"badge badge-pill badge-warning ml-2\"><i class=\"fa fa-address-book mr-1\"></i>#{node.attr("data-admins-count")} </span>"
#
#  if anchor.children("span").length
#    spans = anchor.children("span").remove()
#
#  anchor.prepend(html)
#
runSearch = ->
  to = false
  v = $("#segments-search-form").find("#q_name_cont").val()
  $('#jstree-container').jstree(true).search(v)
  

$ ->
  #chart = Object.values(Chartkick.charts)[0]
  #chart.chart.generateLegend()

  $('#jstree-container')
    .on  'changed.jstree', (e, data) ->
      return if !data.node
      window.location.pathname = data.node.a_attr.href
    #.on "redraw.jstree", (e, data) ->
    #  #$(".jstree-node").each (i, el) -> redrawNode(el)
    #  return
    .jstree
      "plugins": [ "changed", "wholerow", "search", "types" ],
      "types":
         "default":
           "icon": "fa fa-sitemap"
         "leaf":
           "icon": "fa fa-home"
      "search":
        "show_only_matches": true
        "ajax":
          "url": "/segments/jstree_search.json",
          'data' : (str) -> { "search_str" : str }
      ,"core":
        "data":
          "url": "/segments/jstree_segment.html",
          "data": (node) ->
            { 'id': node.id, 'current-segment-id': $("#segments-index").attr("data-current-segment-id") }

  $("#segments-search-form").submit (e)-> e.preventDefault()
  to = false;
  $("#segments-search-form").keyup (e)->
    if to then clearTimeout(to)
    to = setTimeout =>
      runSearch()
    , 250

  #$.each Chart.instances, (index, chart) ->
  #  chart.generateLegend()