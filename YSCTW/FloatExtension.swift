//
//  DoubleExtension.swift
//  YSCTW
//
//  Created by Max Zimmermann on 23.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

extension Float {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
