class ChatSearchesController < ApplicationController
  respond_to :json

  def index
    @segments = fetch_segments
    @users = fetch_users

    respond_with [segments: @segments, users: @users.as_json(methods: :full_name)]
  end

  def fetch_segments
    segment_ids = if current_user.representative?
      representatives_segments_ids
    elsif current_user.only_common?
      current_user.segments.pluck(:id)
    else
      Segment.root.self_and_descendant_ids
    end
    Segment.where(id: segment_ids).ransack(name_cont: params[:q]).result
  end

  def fetch_users
    segment_ids = if current_user.representative?
      representatives_segments_ids
    elsif current_user.only_common?
      current_user.segments.pluck(:id)
    end

    if current_user.representative? || current_user.only_common?
      # A user should be able to talk to anyone in their segments, no matter the role, in the case of representatives all the represented segments and bellow
      # and the non represented segments
      User.joins(user_roles: :role, user_segments: :segment).
        where("user_segments.segment_id IN (#{segment_ids.compact.join(', ')})").
        where("users.id != #{current_user.id}").ransack(name_or_mother_last_name_or_father_last_name_cont: params[:q]).result
    else
      User.where("users.id != #{current_user.id}").ransack(name_or_mother_last_name_or_father_last_name_cont: params[:q]).result
    end
  end

  def representatives_segments_ids
    (current_user.represented_segments.map(&:self_and_descendant_ids).flatten + current_user.non_represented_segments.pluck(:id)).uniq.compact
  end
end
