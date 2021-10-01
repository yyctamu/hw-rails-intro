class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
    # Part 2 and Part 3 Section 
      @items_sort = params[:sort] or session[:sort]
      @movies_ratings = Movie.ratings
      
      
      @entire_ratings =  params[:ratings] or session[:ratings]
      
      if not @entire_ratings
        session[:ratings] = {}
        
        for rating in @movies_ratings
          session[:ratings][rating] = 1
        end
        
        @entire_ratings = session[:ratings]
      end
      
      @movies = Movie.order(@items_sort)
      if @entire_ratings
        @movies = Movie.where(:rating=> @entire_ratings.keys).order(@items_sort)
      end 
      
      if not params[:sort]==session[:sort] 
        params[:ratings] = session[:ratings] = @entire_ratings
        params[:sort] = session[:sort] = @items_sort
        
        flash.keep
        
        redirect_to movies_path(:sort=>params[:sort],:ratings=>params[:ratings])
      end 
      
      if not params[:ratings]==session[:ratings]
        params[:ratings] = session[:ratings] = @entire_ratings
        params[:sort] = session[:sort] = @items_sort
        
        flash.keep
        
        redirect_to movies_path(:sort=>params[:sort],:ratings=>params[:ratings])
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end 