//
//  add_page_button.swift
//  baspbp-final
//
//  Created by nikul on 5/2/18.
//  Copyright © 2018 isv. All rights reserved.
//

import UIKit

@IBDesignable
class add_page_button: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
