//
//  StringExtension.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

extension String {
    func stringSize(attribute: [String : AnyObject], size: CGSize) -> CGSize {
        let attributedText = NSAttributedString.init(string: self, attributes: attribute)
        return attributedText.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size
    }
}
