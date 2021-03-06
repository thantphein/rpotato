class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @redirect = 0

    @checked = {}
    @all_ratings = ['G','PG','PG-13','R']
    @all_ratings.each {|rating|
      if params[:ratings] == nil
        @checked[rating] = true
      else
	@checked[rating] = params[:ratings].has_key?(rating)
      end}

    if (@checked != nil)
        @movies = @movies.find_all{|m| @checked.has_key?(m.rating) and @checked[m.rating] == true}
    end

    if (params[:sort_by].to_s == 'title')
	session[:sort_by] = params[:sort_by]
	@movies = @movies.sort_by{|m| m.title}
    elsif (params[:sort_by].to_s == 'release_date')
	session[:sort_by] = params[:sort_by]
	@movies = @movies.sort_by{|m| m.release_date.to_s}
    elsif (session.has_key?(:sort_by))
	params[:sort_by] = session[:sort_by]
        @redirect = 1
    end
    
    if (params[:ratings] != nil)
      session[:ratings] = params[:ratings]
      @movies = @movies.find_all{|m| params[:ratings].has_key?(m.rating)}
    elsif (session.has_key?(:ratings))
      params[:ratings] = session[:ratings]
      @redirect = 1
    end

    if (@redirect == 1)
      redirect_to movies_path(:sort_by=>params[:sort_by], :ratings=>params[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
