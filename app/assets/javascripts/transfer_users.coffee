# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#from-tree')
    .on 'changed.jstree', (e, data) ->
      window.from_segment = data.node.li_attr["segment-id"]
    .on "redraw.jstree", (e, data) ->
      $("#from-tree .jstree-node").each (i, el) ->
        badge_class = null

        if $(el).attr("data-users-count") == "0"
          badge_class = "secondary"
        else
          badge_class = "success"

        html = "<span class=\"badge badge-pill badge-#{badge_class} ml-2\"><i class=\"fa fa-users mr-1\"></i>#{$(el).attr("data-users-count")} </span>"
        if $(el).children(".jstree-anchor").children("span").length
          $(el).children(".jstree-anchor").children("span").replaceWith(html)
        else
          $(el).children(".jstree-anchor").prepend(html)
    .jstree
      "plugins": [ "changed", "wholerow" ],
      "core":
        "data":
          "url": "/transfer_users/jstree_segment.html",
          "data": (node) -> { 'id': node.id }

  $('#to-tree')
    .on 'changed.jstree', (e, data) ->
      window.to_segment = data.node.li_attr["segment-id"]
    .on "redraw.jstree", (e, data) ->
      $("#to-tree .jstree-node").each (i, el) ->
        badge_class = null

        if $(el).attr("data-users-count") == "0"
          badge_class = "secondary"
        else
          badge_class = "success"
        html = "<span class=\"badge badge-pill badge-#{badge_class} ml-2\"><i class=\"fa fa-users mr-1\"></i>#{$(el).attr("data-users-count")} </span>"
        if $(el).children(".jstree-anchor").children("span").length
          $(el).children(".jstree-anchor").children("span").replaceWith(html)
        else
          $(el).children(".jstree-anchor").prepend(html)
    .jstree
      "plugins": [ "changed", "wholerow" ],
      "core":
        "data":
          "url": "/transfer_users/jstree_segment.html",
          "data": (node) -> { 'id': node.id }

  $('#transfer-users-select').click (e)->
    e.preventDefault()
    if window.from_segment && window.to_segment
      window.location = $(e.currentTarget).attr("data-transfer-path").split("?")[0] + "?from_id=#{window.from_segment}&to_id=#{window.to_segment}"
    else if !window.from_segment
      $.notify("Por favor elija de donde transferir ususarios", { globalPosition: "top center" });
    else if !window.to_segment
      $.notify("Por favor elija hacia donde transferir ususarios", { globalPosition: "top center" });

  $(".user-transfer-list-item").click (e) ->
    e.preventDefault()
    $(e.currentTarget).toggleClass("active")

  $("#transfer-users-link").click (e) ->
    e.preventDefault()
    $.post $(e.currentTarget).attr("data-path"),
      { users_ids: $.map $(".user-transfer-list-item.active"), (val, i)-> $(val).attr("user-id") },
      ((a, b, c) ->
        console.log(a)
        console.log b
        console.log c
      ),
      "script"
      