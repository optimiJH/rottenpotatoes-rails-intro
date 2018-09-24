class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    unless params[:ratings].nil?
      @checked_ratings = params[:ratings]
      session[:checked_ratings] = @checked_ratings
    end

    if params[:sort_by].nil?
    else
      session[:sort_by] = params[:sort_by]
    end

    if params[:sort_by].nil? && params[:ratings].nil? && session[:checked_ratings]
      @checked_ratings = session[:checked_ratings]
      @sorti_by = session[:sort_by]
      flash.keep
      redirect_to movies_path({order_by: @sort_by, ratings: @checked_ratings})
    end

    @movies = Movie.all

    if session[:checked_ratings]
      @movies = @movies.select{ |movie| session[:checked_ratings].include? movie.rating }
    end

    if session[:sort_by] == "title"
      @movies = @movies.sort! { |a,b| a.title <=> b.title }
      @movie_highlight = "hilite"
    elsif session[:sort_by] == "release_date"
      @movies = @movies.sort! { |a,b| a.release_date <=> b.release_date }
      @date_highlight = "hilite"
    else
      
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end