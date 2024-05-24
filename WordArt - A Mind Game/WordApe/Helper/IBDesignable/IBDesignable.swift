//
//  IBDesignable.swift
//  WordArt
//
//

import Foundation
import UIKit

// MARK:- IBDesignable for UIView
@IBDesignable class customTileView: UIView {
   
        @IBInspectable
        public var cornerRadius: CGFloat
        {
            set (radius) {
                self.layer.cornerRadius = radius
                self.layer.masksToBounds = radius > 0
            }

            get {
                return self.layer.cornerRadius
            }
        }

        @IBInspectable
        public var borderWidth: CGFloat
        {
            set (borderWidth) {
                self.layer.borderWidth = borderWidth
            }

            get {
                return self.layer.borderWidth
            }
        }

        @IBInspectable
        public var borderColor:UIColor?
        {
            set (color) {
                self.layer.borderColor = color?.cgColor
            }

            get {
                if let color = self.layer.borderColor
                {
                    return UIColor(cgColor: color)
                } else {
                    return nil
                }
            }
        }
}
extension UIView {
    func applyRoundedCorners(_ radius: CGFloat? = nil) {
        
        self.layer.cornerRadius = radius ?? self.frame.height / 2
        self.layer.masksToBounds = true
    }
}


class KeyView : UIView
{
    func setup() {
        self.applyRoundedCorners(5.0)
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

class KeyboardButton: UIButton {
    func setup() {
        self.titleLabel?.font = .systemFont(ofSize: 25.0)
        self.tintColor = UIColor.white
        if self.tag == 101 {
            self.backgroundColor = .red
        } else {
            self.backgroundColor = ThemeColor.themeLightGrey
        }
        
    }
    override func awakeFromNib() {
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

@IBDesignable class customButton: UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
