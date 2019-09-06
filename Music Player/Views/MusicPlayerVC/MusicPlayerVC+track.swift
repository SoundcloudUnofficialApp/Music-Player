

import UIKit


public extension PlayerVC {
  
    //MARK: current track + Plist
    
    var currentTrackName: String {
        return PlistManager.trackName(currentTrackIndex)
    }
    var currentArtistName: String {
        return PlistManager.artist(currentTrackIndex)
    }
    var currentAlbum: String {
        return PlistManager.album(currentTrackIndex)
    }
    var currentArtworkName: String {
        return PlistManager.artworkName(currentTrackIndex)
    }
    var currentArtworkImage: UIImage {
        return UIImage(named: currentArtworkName)!
    }
    var currentTrackURL: URL {
        return getTrackURL(named:currentTrackName)
    }
    var currentTrackLength: Double {
        return getTrackDuration(audioFileURL: currentTrackURL)
    }
    
    //MARK: displayed track + Plist
    
    var displayedTrackName: String {
        return PlistManager.trackName(displayedTrackIndex)
    }
    var displayedArtistName: String {
        return PlistManager.artist(displayedTrackIndex)
    }
    var displayedAlbum: String {
        return PlistManager.album(displayedTrackIndex)
    }
    var displayedArtworkName: String {
        return PlistManager.artworkName(displayedTrackIndex)
    }
    var displayedArtworkImage: UIImage {
        return UIImage(named: displayedArtworkName)!
    }
    var displayedTrackURL: URL {
        return getTrackURL(named: displayedTrackName)
    }
    
    var displayedTrackLength: Double {
        return getTrackDuration(audioFileURL: displayedTrackURL)
    }
    
    private func getTrackURL(named trackName: String,
                             filetype: String = "mp3") -> URL {
        return URL(fileURLWithPath: Bundle.main.path(forResource: trackName, ofType: filetype)!)
    }
}
