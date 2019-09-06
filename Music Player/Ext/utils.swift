

import Foundation


func makeProgressString(duration: TimeInterval) -> String {
    guard duration != 0.0 else {
        return "00:00"
    }
    
    // let hour_   = abs(Int(duration)/3600)
    let minute_ = abs(Int((duration/60).truncatingRemainder(dividingBy: 60)))
    let second_ = abs(Int(duration.truncatingRemainder(dividingBy: 60)))
    
    // var hour = hour_ > 9 ? "\(hour_)" : "0\(hour_)"
    let minute = minute_ > 9 ? "\(minute_)" : "0\(minute_)"
    let second = second_ > 9 ? "\(second_)" : "0\(second_)"
    return "\(minute):\(second)"
}

