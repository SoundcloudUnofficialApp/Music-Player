

import UIKit
import SwiftyUserDefaults



public extension PlayerVC {
    
    //MARK: Defaults
    
    /// currently played / paused track
    var currentTrackIndex: Int {
        get {
            return Defaults[\.currentTrackIndex]
        }
        set {
            Defaults[\.currentTrackIndex] = newValue
        }
    }
    
    /// time elapsed since start for currently played/paused track
    var currentTrackProgress: Double {
        get {
            return Defaults[\.currentTrackProgress]
        }
        set {
            Defaults[\.currentTrackProgress] = newValue
        }
    }
    
    //MARK: displayed track
    
    /// user can play one track and look at some other
    var displayedTrackIndex: Int! {
        get {
            return Defaults[\.displayedTrackIndex]
        }
        set {
            Defaults[\.displayedTrackIndex] = newValue
        }
    }
    
    /// user may check other tracks, then slider update is not needed until he presses to play it
    var currentTrackIsDisplayed: Bool {
        return currentTrackIndex == displayedTrackIndex
    }
    
    //MARK: Play modes
    
    //TODO: consider making struct to describe player settings
    
    var isShuffleModeOn: Bool {
        get {
            return Defaults[\.isShuffleModeOn]
        }
        set {
            Defaults[\.isShuffleModeOn] = newValue
        }
    }
    
    var isRepeatModeOn: Bool {
        get {
            return Defaults[\.isRepeatModeOn]
        }
        set {
            Defaults[\.isRepeatModeOn] = newValue
        }
    }
    
    /// if true - when next or previous buttons tapped - starts playing, otherwise continues to play current track
    var startPlayWhenSwitched: Bool {
        get {
            return Defaults[\.startPlayWhenSwitched]
        }
        set {
            Defaults[\.startPlayWhenSwitched] = newValue
        }
    }
}
