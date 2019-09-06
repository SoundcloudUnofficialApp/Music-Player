


import SwiftyUserDefaults

extension DefaultsKeys {
    
    var isShuffleModeOn: DefaultsKey<Bool> {
        .init("isShuffleModeOn", defaultValue: false)
    }
    
    var isRepeatModeOn: DefaultsKey<Bool> {
        .init("isRepeatModeOn", defaultValue: false)
    }
    
    var startPlayWhenSwitched: DefaultsKey<Bool> {
        .init("startPlayWhenSwitched", defaultValue: false)
    }
    
    /// playerProgressSliderValue
    var currentTrackProgress: DefaultsKey<Double> {
        .init("currentTrackProgress", defaultValue: 0.0)
    }
    
    var currentTrackIndex: DefaultsKey<Int> {
        .init("currentTrackIndex", defaultValue: 0)
    }
    
    var displayedTrackIndex: DefaultsKey<Int?>{
        .init("displayedTrackIndex")
    }
}

