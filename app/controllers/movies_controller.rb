class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def index
    @movies = Movie.all
  end
  def show
    id = params[:id]
    @movie = Movie.find(id)
  end
  def new
    @movie = Movie.new
  end
  def create

    @movie = Movie.create!(movie_params)
    redirect_to movies_path
    flash[:notice] = "#{@movie.title} was successfully created."
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    respond_to do |client_wants|
      client_wants.html { redirect_to movie_path(@movie) }
      client_wants.xml { render :xml => @movie.to_xml }
    end
    flash[:notice] = "#{@movie.title} was successfully updated"

  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was successfully deleted"
    redirect_to movies_path
  end
end
