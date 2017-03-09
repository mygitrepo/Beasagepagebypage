//
//  String.swift
//  baspbp-final
//
//  Created by nikul on 2/20/17.
//  Copyright © 2017 isv. All rights reserved.
//

import Foundation

extension String {
    var isNumeric: Bool {
        let range = self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted)
        return (range == nil)
    }
}
