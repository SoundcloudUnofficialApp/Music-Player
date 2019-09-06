

import UIKit
import AVFoundation
import SwiftyUserDefaults

extension PlayerVC: AVAudioPlayerDelegate {}

public extension PlayerVC {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        guard flag else {
            return
        }
        
        if isShuffleModeOn == false,
            isRepeatModeOn == false {
            
            // play next
            //playButton.setPlayImage()
            switchToNextTrack()
            playDisplayedTrack()
            
        } else if isRepeatModeOn,
            isShuffleModeOn == false {
            
            //repeat same song
            playCurrentTrack(progress: 0)
            
        } else if isShuffleModeOn,
            isRepeatModeOn == false {
            //shuffle songs but do not repeat at the end
            //Shuffle Logic : Create an array and put current song into the array then when next song come randomly choose song from available song and check against the array it is in the array try until you find one if the array and number of songs are same then stop playing as all songs are already played.
            shuffleArray.append(currentTrackIndex)
            guard shuffleArray.count < PlistManager.audioList.count else {
                playButton.setPlayImage()
                return
            }
            
            var randIdx = 0
            var newIndex = false
            while newIndex == false {
                
                randIdx = PlistManager.randTrackIdx
                newIndex = !shuffleArray.contains(randIdx)
            }
            currentTrackIndex = randIdx
            playCurrentTrack()
            
        } else if isShuffleModeOn, isRepeatModeOn {
            
            //shuffle song endlessly
            shuffleArray.append(currentTrackIndex)
            if shuffleArray.count >= PlistManager.audioList.count {
                shuffleArray.removeAll()
            }
            
            var randIdx = 0
            var newIndex = false
            while newIndex == false {
                
                randIdx =  PlistManager.randTrackIdx
                newIndex = !shuffleArray.contains(randIdx)
            }
            currentTrackIndex = randIdx
            playCurrentTrack()
        }
    }
}
