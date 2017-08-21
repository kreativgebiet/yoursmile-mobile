//
//  SliderExtension.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

extension UISlider {
    var thumbCenterX: CGFloat {
        let trackRect = self.trackRect(forBounds: frame)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return thumbRect.midX
    }
}
