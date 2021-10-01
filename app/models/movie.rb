class Movie < ActiveRecord::Base
    def self.ratings 
        
        ary = []
        Movie.select(:rating).distinct.each{ |w| ary.push(w.rating) }
        ary.sort
        
    end 
    
end