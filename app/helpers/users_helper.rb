module UsersHelper
  def users_index_filter_path(filter, clear = nil)
    window_filters = clear ? params[:q].except(clear) : params[:q] if params[:q]
    # This is the helper for the route
    if @segment
      segment_users_path(@segment, q: filter.merge(window_filters || {}))
    else
      users_path(q: filter.merge(window_filters || {}))
    end
  end

  def users_search_url
    if @segment
      # TODO: complete this behavior
    else
      users_path(q: params[:q] || {})
    end
  end
end
