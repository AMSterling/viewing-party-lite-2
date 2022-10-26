class MoviesController < ApplicationController
  def index
    if params[:q] == 'top_rated'
      @top_movies = MovieFacade.top_rated
    else params[:q]
      @searched_movies = MovieFacade.search(params[:q])
    end
  end

  def show
    @movie = MovieFacade.details(params[:id])
  end
end
