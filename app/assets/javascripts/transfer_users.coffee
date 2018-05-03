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

  $('#from-tree')
    .on 'changed.jstree', (e, data) -> window.from_segment = data.node.li_attr["segment-id"]
    .on "redraw.jstree", (e, data) -> $("#from-tree .jstree-node").each (i, el) -> redrawNode(el)
    .jstree
      "plugins": [ "changed", "wholerow", "search" ],
      "search":
        "show_only_matches": true
        "ajax":
          "url": "/segments/jstree_search.json",
          'data' : (str) -> { "search_str" : str }
      , "core":
        "data":
          "url": "/transfer_users/jstree_segment.html",
          "data": (node) -> { 'id': node.id }

  $('#to-tree')
    .on 'changed.jstree', (e, data) -> window.to_segment = data.node.li_attr["segment-id"]
    .on "redraw.jstree", (e, data) -> $("#to-tree .jstree-node").each (i, el) -> redrawNode(el)
    .jstree
      "plugins": [ "changed", "wholerow", "search" ],
      "search":
        "show_only_matches": true
        "ajax":
          "url": "/segments/jstree_search.json",
          'data' : (str) -> { "search_str" : str }
      , "core":
        "data":
          "url": "/transfer_users/jstree_segment.html",
          "data": (node) -> { 'id': node.id }

  bindSearch = (element, source_tree)->
    to = false;
    element.keyup (e)->
      if to then clearTimeout(to)
      to = setTimeout =>
        v = element.val();
        $(source_tree).jstree(true).search(v);
      , 250

  bindSearch($("#from-segments-search-input"), "#from-tree")
  bindSearch($("#to-segments-search-input"), "#to-tree")

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

      