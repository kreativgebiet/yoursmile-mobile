//
//  StringHelperFunctions.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

func attributedTexts(text1: String, attribs1: [NSAttributedStringKey : Any]?, text2: String, attribs2: [NSAttributedStringKey : Any]?) -> NSMutableAttributedString {
    
    let str = NSMutableAttributedString(string: text1, attributes: attribs1);
    str.append(NSAttributedString(string: text2, attributes: attribs2))
    
    return str
}
