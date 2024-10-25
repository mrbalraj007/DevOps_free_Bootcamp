data "spotify_search_track" "by_artist" {
  artist = "Kishore Kumar"
  #  album = "Jolene"
  #  name  = "Early Morning Breeze"
}

resource "spotify_playlist" "Bollywood_Golden_Era_playlist" {
  name        = "Bollywood_Golden_Era_playlist"
  description = "This playlist was created by Terraform"
  public      = true


  tracks = flatten([
    data.spotify_search_track.by_artist.tracks[*].id,
  ])
}


#  tracks = [
#    data.spotify_search_track.by_artist.tracks[0].id,
#    data.spotify_search_track.by_artist.tracks[1].id,
#    data.spotify_search_track.by_artist.tracks[2].id
#  ]
#}

output "playlist_url" {
  value       = "https://open.spotify.com/playlist/${spotify_playlist.Bollywood_Golden_Era_playlist.id}"
  description = "Visit this URL in your browser to listen to the playlist"
}
