//
//  DateExtension.swift
//  YSCTW
//
//  Created by Max Zimmermann on 28.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs as Date) == .orderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs as Date) == .orderedAscending
}

extension NSDate: Comparable { }
