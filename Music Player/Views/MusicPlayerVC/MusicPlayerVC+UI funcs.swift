

import UIKit
import UIFontComplete


public extension PlayerVC {
    
    /// if progress is nil - assumes 0
    func setupProgressUI(trackLength: Double,
                         progress: Double = 0.0) {
        setupTrackLength(trackLength)
        updateProgressUI(progress:progress)
    }
    
    func setupTrackLength(_ trackLength: Double) {
        progressSlider.minimumValue = 0.0
        progressSlider.maximumValue = trackLength.float
        trackLengthLabel.text = makeProgressString(duration: trackLength)
    }
    
    /// updates progress slider and timer views with given progress
    func updateProgressUI(progress: Double) {
        progressSlider.value = progress.float
        progressTimerLabel.text = makeProgressString(duration: progress)
    }
    
    /// sets track name, artist, album, artwork based on current track index
    func updateTrackInfoUIForDisplayedTrack() {
        artistLabel.text = displayedArtistName
        albumLabel.text = displayedAlbum
        trackNameLabel.text = displayedTrackName
        
        // testing gesture
        albumArtworkImageView.image = displayedArtworkImage
    }
}
