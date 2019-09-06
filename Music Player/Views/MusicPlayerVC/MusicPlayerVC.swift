import UIKit
import AVFoundation
import MediaPlayer


open class PlayerVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var albumArtworkImageView: UIImageView!
    
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var trackLengthLabel: UILabel!
    @IBOutlet weak var progressTimerLabel: UILabel!
    
    // controls
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
        
    //Choose background here. Between 1 - 7
    fileprivate static let backgroundImageIndex = 1
    
    var shuffleArray = [Int]()
    
    var audioPlayer: AVAudioPlayer!
    
    fileprivate var timer: Timer!
    
    /// number of seconds between progress UI updates
    fileprivate let progressUpdateFrequency: Double = 0.3

    
    var isPlaying: Bool {
        guard let player = audioPlayer else {
            return false
        }
        return player.isPlaying
    }
    
    //MARK: View life cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = Self.backgroundImage
        _initSlider()
       
        /// initially, display currently played/paused track
        displayedTrackIndex = currentTrackIndex
        
        updateUIForCurrentTrack(progress: currentTrackProgress)
        
        shuffleButton.isSelected = isShuffleModeOn
        repeatButton.isSelected = isRepeatModeOn
        
        //LockScreen Media control registry
        
        guard UIApplication.shared.responds(to: #selector(UIApplication.beginReceivingRemoteControlEvents)) else {
            return
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        UIApplication.shared.beginBackgroundTask()
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        albumArtworkImageView.setRounded()
    }
    
    fileprivate func _initSlider () {
        guard let sl = progressSlider else {
            return
        }
        sl.setMinimumTrackImage(Asset.sliderTrackFill.image,
                                for: .normal)
        
        sl.setMaximumTrackImage(Asset.sliderTrack.image,
                                for: .normal)
        
        sl.setThumbImage(Asset.thumb.image,
                         for: .normal)
    }
  
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    //MARK: IBActions
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        
        if isShuffleModeOn {
            shuffleArray.removeAll()
        }
        
        if isPlaying && currentTrackIsDisplayed {
            // button is in play mode
            pausePlaying()
            
        } else {
            // button is in pause mode
            //switch to new track or was paused
            playDisplayedTrack()
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: AnyObject) {
        switchToNextTrack()
    }
    
    /// switches track and updates UI with new track
    func switchToNextTrack() {
        
        guard displayedTrackIndex != PlistManager.audioList.count - 1 else {
            _displayedTrackSwitched()
            return
        }
        
        displayedTrackIndex += 1
        if displayedTrackIndex == PlistManager.audioList.count - 1 {
            nextButton.isEnabled = false
        }
        prevButton.isEnabled = true
        
        _displayedTrackSwitched()
    }
    
    @IBAction func prevButtonTapped(_ sender: AnyObject) {
        switchToPreviousTrack()
    }
    
    /// switches track and updates UI with a new track
    func switchToPreviousTrack() {
        
        guard displayedTrackIndex != 0 else {
            _displayedTrackSwitched()
            return
        }
        
        displayedTrackIndex -= 1
        if displayedTrackIndex == 0 {
            prevButton.isEnabled = false
        }
        nextButton.isEnabled = true
        
        _displayedTrackSwitched()
    }
    
    /// when pressing next / previous, but the index of the track is not first or last
    fileprivate func _displayedTrackSwitched() {
        
        if currentTrackIsDisplayed {
            updateUIForDisplayedTrack(progress: currentTrackProgress)
        } else {
            updateUIForDisplayedTrack()
        }
        
        if startPlayWhenSwitched,
            isPlaying,
            !currentTrackIsDisplayed {
            
            // switch to new track with progress slider value
            playDisplayedTrack()
        }
    }
    
    @IBAction func trackProgessSliderDragged(_ sender: UISlider) {
        
        let progress = TimeInterval(sender.value)
        progressTimerLabel.text = makeProgressString(duration: progress)
        
        if currentTrackIsDisplayed {
            audioPlayer?.currentTime = progress
        }
    }
    
    @IBAction func shuffleButtonTapped(_ sender: UIButton) {
        shuffleArray.removeAll()
        isShuffleModeOn = !sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func repeatButtonTapped(_ sender: UIButton) {
        isRepeatModeOn = !sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    
    //MARK: timer
    
    func startTimer() {
        guard timer != nil else {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: progressUpdateFrequency, target: self, selector: #selector(Self.update(_:)), userInfo: nil,repeats: true)
        timer.fire()
    }
    
    /// moves slider and updates progress timer
    @objc func update(_ timer: Timer) {
        guard isPlaying else {
            return
        }
        currentTrackProgress = audioPlayer.currentTime
        
        guard currentTrackIsDisplayed else {
            // view is managed by sth else
            return
        }
        // if view was just shown - restore
        updateProgressUI(progress:audioPlayer.currentTime)
    }
    
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    
    //MARK: remote control
    
    override open func remoteControlReceived(with event: UIEvent?) {
        guard let event = event,
            event.type == .remoteControl else {
                return
        }
        switch event.subtype {
        case .remoteControlPlay:
            playButtonTapped(self)
        case .remoteControlPause:
            playButtonTapped(self)
        case .remoteControlNextTrack:
            nextButtonTapped(self)
        case .remoteControlPreviousTrack:
            prevButtonTapped(self)
        default:
            print("There is an issue with the control")
        }
    }
    
    // This shows media info on lock screen - used currently and perform controls
    func showMediaInfo() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyArtist : currentArtistName,  MPMediaItemPropertyTitle : currentTrackName
        ]
    }
    

    //MARK: -
    
    /// returns image for currently set backgroundImageIndex
    fileprivate static var backgroundImage: UIImage {
        let asset: ImageAsset
        switch backgroundImageIndex {
        case 1:
            asset = Asset.background2
        case 2:
            asset = Asset.background2
        case 3:
            asset = Asset.background3
        case 4:
            asset = Asset.background4
        case 5:
            asset = Asset.background5
        case 6:
            asset = Asset.background6
        case 7:
            asset = Asset.background7
        default:
            fatalError()
        }
        return asset.image
    }
}

