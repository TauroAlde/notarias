# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  #chart = Object.values(Chartkick.charts)[0]
  #chart.chart.generateLegend()

  $('#jstree-container')
    .on  'changed.jstree', (e, data) ->
      return if !data.node
      window.location.pathname = data.node.a_attr.href
    .on "redraw.jstree", (e, data) ->
      $(".jstree-node").each (i, el) ->
        badge_class = null

        if $(el).attr("data-users-count") == "0"
          badge_class = "secondary"
        else
          badge_class = "success"

        html = "<span class=\"badge badge-pill badge-#{badge_class} ml-2\"><i class=\"fa fa-users mr-1\"></i>#{$(el).attr("data-users-count")} </span>"
        if $(el).children(".jstree-anchor").children("span").length
          $(el).children(".jstree-anchor").children("span").replaceWith(html)
        else
          $(el).children(".jstree-anchor").append(html)
    .jstree
      "plugins": [ "changed", "wholerow" ],
      "core":
        "data":
          "url": "/segments/jstree_segment.html",
          "data": (node) ->
            { 'id': node.id, 'current-segment-id': $("#segments-index").attr("data-current-segment-id") }
