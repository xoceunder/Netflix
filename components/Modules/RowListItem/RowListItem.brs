sub init()
    
end sub

sub setContent(event)
    movie = event.getData()
    m.top.moviePoster = movie.SDPosterURL
end sub