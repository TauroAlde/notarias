# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
redrawNode = (el) ->
  node = $(el)
  anchor = node.children(".jstree-anchor")
  badge_class = null

  if node.attr("data-users-count") == "0"
    badge_class = "secondary"
  else
    badge_class = "success"

  html = "<span class=\"badge badge-pill badge-#{badge_class} ml-2\"><i class=\"fa fa-users mr-1\"></i>#{node.attr("data-users-count")} </span>"
  if $(el).attr("data-admins-count") != "null"
    html += "<span class=\"badge badge-pill badge-warning ml-2\"><i class=\"fa fa-address-book mr-1\"></i>#{node.attr("data-admins-count")} </span>"

  if anchor.children("span").length
    spans = anchor.children("span").remove()

  anchor.prepend(html)

$ ->
  #chart = Object.values(Chartkick.charts)[0]
  #chart.chart.generateLegend()

  $('#jstree-container')
    .on  'changed.jstree', (e, data) ->
      return if !data.node
      window.location.pathname = data.node.a_attr.href
    .on "redraw.jstree", (e, data) -> $(".jstree-node").each (i, el) -> redrawNode(el)
    .jstree
      "plugins": [ "changed", "wholerow" ],
      "core":
        "data":
          "url": "/segments/jstree_segment.html",
          "data": (node) ->
            { 'id': node.id, 'current-segment-id': $("#segments-index").attr("data-current-segment-id") }
