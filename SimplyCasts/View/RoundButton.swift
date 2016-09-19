//
//  RoundButton.swift
//  SimplyCasts
//
//  Created by felix on 9/13/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override var highlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override var selected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        var radius: CGFloat = 0.0
        if self.frame.width < self.frame.height {
            radius = self.frame.width / 3
        } else {
            radius = self.frame.height / 3
        }
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    private func updateBackgroundColor() {
        if highlighted {
            backgroundColor = UIColor(red: 0.298, green: 0.5137, blue: 0.7451, alpha: 1.0)
        } else if selected {
            backgroundColor = UIColor(red: 0.2745, green: 0.5529, blue: 0.9294, alpha: 1.0)
        } else {
            backgroundColor = UIColor.clearColor()
        }
    }
}
