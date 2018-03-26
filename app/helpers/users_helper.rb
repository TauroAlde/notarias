module UsersHelper
  def users_index_filter_path(filter, clear = nil)
    window_filters = clear ? params[:q].except(clear) : params[:q] if params[:q]
    users_path(q: filter.merge(window_filters || {}))
  end
end
