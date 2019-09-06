

import UIKit


extension Double {
    var float: Float {
        return Float(self)
    }
}
extension Float {
    var double: Double {
        return Double(self)
    }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}

extension UIImageView {
    
    func setRounded() {
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true
    }
}
extension UIButton {
    func setPlayImage(){
        setImage(Asset.play.image, for: .normal)
    }
    func setPauseImage(){
        setImage(Asset.pause.image, for: .normal)
    }
}
