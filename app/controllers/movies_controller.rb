class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    @movies = Movie.all
    
    @all_ratings = Movie.ratings
    session[:sort_by] ||= 'id'
    session[:ratings] ||= Hash[@all_ratings.map {|rating| [rating,1]}]
    if params[:ratings].nil?
      @ratings_desired = session[:ratings].keys
    else 
      @ratings_desired = params[:ratings].keys
      # store the info for the next time
      session[:ratings] = params[:ratings]
    end
    if params[:sort_by].nil?
      @sort = session[:sort_by]
    else 
      @sort = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    
    if params[:sort_by].nil? || params[:ratings].nil?
      flash.keep
      # see rake routes (movies path is controlled by index)
      redirect_to movies_path(ratings: session[:ratings], sort_by: session[:sort_by])
    end
    
    
    if @sort == "title"
      @title_hilite = "hilite"
    elsif @sort == "release_date"
      @date_hilite = "hilite"
    end
    
    
    @movies = Movie.where(rating: @ratings_desired).order(@sort)
    
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
