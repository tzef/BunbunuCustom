//
//  FilterButton.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift

private let unFlagBgColor = UIColor(rgba: "#dcdce4")
private let flagBGColor = UIColor.whiteColor()
private let unFlagBorderColor = UIColor.blackColor()
private let flagBorderColor = UIColor(rgba: "#53BC4A")
private let unFlagIconColor = UIColor(rgba: "#999999")
private let flagIconColor = UIColor(rgba: "#53BC4A")

@IBDesignable
class ToggleButton: StyleButton {
    @IBInspectable var flag: Bool = false {
        didSet {
            self.borderColor = (flag ? flagBorderColor : unFlagBorderColor)
            self.bgColor = (flag ? flagBGColor : unFlagBgColor)
            self.setNeedsDisplay()
        }
    }
    
    convenience init(flag: Bool, icon: UIImage?, title: String, clickClosure: (() -> ())?) {
        self.init(borderWidth: 1, borderColor: (flag ? flagBorderColor : unFlagBorderColor), bgColor: (flag ? flagBGColor : unFlagBgColor), textColor: UIColor.blackColor(), highlightBorderColor: nil, highlightBgColor: nil, highlightTextColor: nil, disabledColor: UIColor.lightGrayColor(), cornerRadius: CornerRadiusIntensity.Quarter, clickClosure: clickClosure)
        self.clickClosure = clickClosure
        self.flag = flag
        self.iconImage = icon
        self.iconMargin = 24.0
        self.titleLabel?.font = UIFont.systemFontOfSize(15.0)
        self.setTitle(title, forState: .Normal)
    }
    
    override func clickEvent() {
        self.flag = !self.flag
        self.setNeedsDisplay()
        clickClosure?()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let flagIconSize = CGSizeMake(rect.size.height / 3, rect.size.height / 3)
        let flagIconMargin = (rect.height - flagIconSize.height) / 2
        let flagIconRect = CGRect(x: flagIconMargin, y: flagIconMargin, width: flagIconSize.width, height: flagIconSize.height)
        let flagIconPath = UIBezierPath()
        flagIconPath.lineCapStyle = CGLineCap.Round
        flagIconPath.lineWidth = 3
        if flag {
            flagIconColor.setStroke()
            flagIconPath.moveToPoint(CGPoint(x: CGRectGetMinX(flagIconRect), y: CGRectGetMinY(flagIconRect)))
            flagIconPath.addLineToPoint(CGPoint(x: CGRectGetMaxX(flagIconRect), y: CGRectGetMaxY(flagIconRect)))
            flagIconPath.moveToPoint(CGPoint(x: CGRectGetMaxX(flagIconRect), y: CGRectGetMinY(flagIconRect)))
            flagIconPath.addLineToPoint(CGPoint(x: CGRectGetMinX(flagIconRect), y: CGRectGetMaxY(flagIconRect)))
        } else {
            unFlagIconColor.setStroke()
            flagIconPath.moveToPoint(CGPoint(x: CGRectGetMidX(flagIconRect), y: CGRectGetMinY(flagIconRect)))
            flagIconPath.addLineToPoint(CGPoint(x: CGRectGetMidX(flagIconRect), y: CGRectGetMaxY(flagIconRect)))
            flagIconPath.moveToPoint(CGPoint(x: CGRectGetMinX(flagIconRect), y: CGRectGetMidY(flagIconRect)))
            flagIconPath.addLineToPoint(CGPoint(x: CGRectGetMaxX(flagIconRect), y: CGRectGetMidY(flagIconRect)))
        }
        flagIconPath.stroke()
    }
}
