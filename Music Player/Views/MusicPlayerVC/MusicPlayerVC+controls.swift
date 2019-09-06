import UIKit
import AVFoundation


extension PlayerVC {
    
    
    /// prepares player and starts playing displayedTrackURL with slider progress
    /// if progress is nil - uses progressSlider.value
    /// can silently throws if URL is invalid - check error log
    func playDisplayedTrack(progress: Double? = nil) {
        
        currentTrackIndex = displayedTrackIndex
        playCurrentTrack(progress: progressSlider.value.double)
    }
    
    /// if progress is not given uses last stored value
    /// prepares player and starts playing currentTrackURL with currentTrackProgress
    /// can silently throws if URL is invalid - check error log
    func playCurrentTrack(progress: Double? = nil) {
        do {
            let p = progress ?? currentTrackProgress
            
            try _playTrack(url: currentTrackURL,
                           progress: p)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pausePlaying() {
        playButton.setPlayImage()
        _pausePlaying()
    }
    
    //MARK: update UI
    
    /// if progress is nil - assumes 0
    func updateUIForCurrentTrack(progress: Double = 0.0) {
        updateUIForTrack(trackLength: currentTrackLength,
                         progress: progress)
    }
    
    /// if progress is nil - progress UI is reset to 0
    func updateUIForDisplayedTrack(progress: Double = 0.0) {
        updateUIForTrack(trackLength: displayedTrackLength,
                         progress: progress)
    }
    
    //MARK: private
    
    /// if progress is nil - progress UI is reset to 0
    fileprivate func updateUIForTrack(trackLength: Double,
                                      progress: Double = 0.0) {
        updateTrackInfoUIForDisplayedTrack()
        
        if displayedTrackIndex == 0 {
            prevButton.isEnabled = false
        } else if displayedTrackIndex == PlistManager.audioList.count - 1 {
            nextButton.isEnabled = false
        }
        
        if isPlaying, currentTrackIsDisplayed {
            // currentTrack is played
            playButton.setPauseImage()
        } else {
            // pause current track or
            // browse in paused mode
            playButton.setPlayImage()
        }
        
        setupProgressUI(trackLength: trackLength,
                        progress: progress)
        
        // lock screen
        showMediaInfo()
    }
    
    fileprivate func _playTrack(url: URL,
                                progress: Double) throws {
        playButton.setPauseImage()
        updateProgressUI(progress: progress)
        
        //TODO: impl init once
         //let playerItem = AVPlayerItem(url: url)
         //audioPlayer.replaceCurrentItem(with: playerItem)
        
        try prepareAudioPlayer(url, progress: progress)
        _startPlaying(at: progress)
    }
    
    /// prepare player before playing
    fileprivate func _startPlaying(at time: TimeInterval) {
        stopTimer()
        
        audioPlayer.currentTime = time
        audioPlayer.play()
        
        startTimer()
    }
    
    fileprivate func _pausePlaying() {
        guard isPlaying else {
            return
        }
        currentTrackProgress = audioPlayer.currentTime
        stopTimer()
        audioPlayer.pause()
    }
    
    fileprivate func _stopPlaying() {
        guard isPlaying else {
            return
        }
        stopTimer()
        audioPlayer.stop()
        currentTrackProgress = 0.0
    }
    
    /// Prepare audio for playing
    fileprivate func prepareAudioPlayer(_ url: URL,
                                        progress: Double = 0.0) throws {
        
        //keep alive audio at background
        try AVAudioSession.sharedInstance().setCategory(.playback)
        try AVAudioSession.sharedInstance().setActive(true)
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.delegate = self
        
        audioPlayer.currentTime = progress
        audioPlayer.prepareToPlay()
    }
}

