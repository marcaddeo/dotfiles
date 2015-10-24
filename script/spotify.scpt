if application "Spotify" is running then
    tell application "Spotify"
        if player state = playing then
            set theName to name of the current track
            set theArtist to artist of the current track
            set theAlbum to album of the current track
            set theUrl to spotify url of the current track
            try
                return theName & " by " & theArtist
            on error err
            end try
        end if
    end tell
end if
