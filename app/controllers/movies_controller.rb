class MoviesController < ApplicationController
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def index
    @movies = Movie.all.order(:title)
  end
  def show
    begin
      @movie = Movie.find params[:id]
    rescue
      redirect_to movies_path
    end
  end
  def new
    @movie = Movie.new
  end
  def create

    @movie = Movie.create(movie_params)
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movie_path(@movie)
    else
      render 'new'
    end
  end

  def edit
    begin
      @movie = Movie.find params[:id]
    rescue
      redirect_to movies_path
    end
  end

  def update
    @movie = Movie.find params[:id]
    if @movie.update_attributes(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated"
      respond_to do |client_wants|
        client_wants.html { redirect_to movie_path(@movie) }
        client_wants.xml { render :xml => @movie.to_xml }
      end
    else
      render 'edit'
    end
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was successfully deleted"
    redirect_to movies_path
  end
end
