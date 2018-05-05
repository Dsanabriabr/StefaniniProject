//
//  FloatingActionButton.swift
//  CalendarioProject
//
//  Created by Daniel Sanabria on 21/04/18.
//  Copyright © 2018 Daniel Sanabria. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButtonX {

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 270))
                self.cornerRadius = 30
                self.backgroundColor = #colorLiteral(red: 0.2094807637, green: 0.4948247145, blue: 0.08993300135, alpha: 1)
                
            } else {
                self.transform = .identity
                self.cornerRadius = 66
                self.backgroundColor = #colorLiteral(red: 0.383265708, green: 1, blue: 0.1924103346, alpha: 1)
            }
        })
        return super.beginTracking(touch, with: event)
    }

}
