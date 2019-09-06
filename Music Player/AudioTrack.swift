
import UIKit

///
struct AudioTrack: Codable, Equatable, CustomStringConvertible {
    
    var url: URL
    
    /// track name
    var name: String?
    
    //TODO: consider making Album model (with release date, label etc)
    var album: String?
    
    var artist: String?
    
    var artworkName: String?
    
    //TODO: consider impl remote as well -> make it storable?
    /// local track duration
    var duration: Double {
        return getTrackDuration(audioFileURL: url)
    }
    
    //TODO: consider storing image here as UIImage
    /// local image URL
    var localArtworkURL: URL? {
        if let fileName = artworkName {
            return getArtworkURL(fileName)
        }
        return nil
    }
    
    //var remoteArtworkURL: URL?
    
    var imageURL: URL? {
        if let name = artworkName {
            return getArtworkURL(name)
        }
        return nil
    }
    var artworkImage: UIImage? {
        if let name = artworkName {
            return UIImage(named: name)
        }
        return nil
    }
    
    /// url is a local file URL
    init(url: URL,
         
         name: String? = nil,
         artist: String? = nil,
         album: String? = nil,
         artworkName: String? = nil) {
        
        self.url = url
        
        self.name = name
        self.artist = artist
        self.album = album
        self.artworkName = artworkName
    }
    
    
    var description: String {
        let r = "AudioTrack"
        //TODO:
        return r
    }
}


/// currenly all images are "*.png"
func getArtworkURL(_ name: String,
                   imageExtension: String = "png") -> URL {
    let filePath = Bundle.main.path(forResource: name, ofType: imageExtension)!
    return URL(fileURLWithPath: filePath)
}


import AVFoundation

func getTrackDuration(audioFileURL: URL) -> Double {
    let audioAsset = AVURLAsset(url: audioFileURL, options: nil)
    return CMTimeGetSeconds(audioAsset.duration)
}
