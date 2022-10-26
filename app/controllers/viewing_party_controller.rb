class ViewingPartyController < ApplicationController
  before_action :require_user

  def new
    @host = current_user
    @movie = MovieFacade.details(params[:movie_id])
    @invitees = User.where.not(id: current_user.id)
  end

  def create
    viewing_party = ViewingParty.create!(
      poster_path: params[:poster_path],
      movie_title: params[:movie_title],
      movie_id: params[:movie_id].to_i,
      host_id: params[:host_id].to_i,
      duration: params[:duration].to_i,
      date: Date.parse(params[:date]),
      start_time: Time.zone.parse(params[:start_time])
    )

    UserViewingParty.create!(user_id: current_user.id, viewing_party_id: viewing_party.id)
      if params[:attendees]
        params[:attendees].each do |attendee|
          UserViewingParty.create!(user_id: attendee.to_i, viewing_party_id: viewing_party.id)
        end
      end
    redirect_to dashboard_path
  end
end
