//
//  StyleButton.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

enum CornerRadiusIntensity: String {
    case Half = "HALF"
    case Quarter = "QUARTER"
    case Little = "LITTLE"
    case None = "NONE"
    func intValue() -> Int {
        switch self {
        case .Half:
            return 2
        case .Quarter:
            return 4
        case .Little:
            return 0
        default:
            return 1
        }
    }
}
enum IconImageStyle: String {
    case Up = "UP"
    case Left = "LEFT"
    case Down = "DOWN"
    case Right = "RIGHT"
}

@IBDesignable
class StyleButton: UIButton {
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var borderColor: UIColor = UIColor.blackColor()
    @IBInspectable var bgColor: UIColor = UIColor.whiteColor()
    @IBInspectable var textColor: UIColor = UIColor.blackColor()
    @IBInspectable var highlightBorder: UIColor?
    @IBInspectable var highlightBg: UIColor?
    @IBInspectable var highlightText: UIColor?
    @IBInspectable var disabledColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable var cornerStyle: String? {
        didSet {
            if let style = CornerRadiusIntensity(rawValue: cornerStyle?.uppercaseString ?? "") {
                cornerRadius = style
            }
        }
    }
    @IBInspectable var iconImage: UIImage?
    @IBInspectable var iconStyle: String? {
        didSet {
            if let style = IconImageStyle(rawValue: iconStyle?.uppercaseString ?? "") {
                iconImageStyle = style
            }
        }
    }
    @IBInspectable var iconPercent: CGFloat = 0.8
    @IBInspectable var iconMargin: CGFloat = 0.0
    var iconImageStyle: IconImageStyle = .Left
    var cornerRadius: CornerRadiusIntensity = .None
    var clickClosure: (() -> ())?
    
    convenience init(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.blackColor(), bgColor: UIColor = UIColor.whiteColor(), textColor: UIColor = UIColor.blackColor(), highlightBorderColor: UIColor?, highlightBgColor: UIColor?, highlightTextColor: UIColor?, disabledColor: UIColor = UIColor.lightGrayColor(), cornerRadius: CornerRadiusIntensity, clickClosure:(() -> ())? ) {
        self.init()
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.bgColor = bgColor
        self.textColor = textColor
        self.highlightBorder = highlightBorderColor
        self.highlightBg = highlightBgColor
        self.highlightText = highlightTextColor
        self.disabledColor = disabledColor
        self.cornerRadius = cornerRadius
        self.addTarget(self, action: #selector(StyleButton.clickEvent), forControlEvents: .TouchUpInside)
    }
    func clickEvent() {
        clickClosure?()
    }
    
    override func drawRect(rect: CGRect) {
        let btnRect = CGRectInset(rect, borderWidth, borderWidth)
        highlightBorder = (highlightBorder != nil ? highlightBorder: borderColor)
        highlightBg = (highlightBg != nil ? highlightBg : bgColor.darkerColor())
        highlightText = (highlightText != nil ? highlightText : textColor)
        (self.highlighted ? highlightBorder! : borderColor).setStroke()
        (self.highlighted ? highlightBg! : bgColor).setFill()
        self.setTitleColor( (self.highlighted ? highlightText! : textColor), forState: .Normal)
        if !self.enabled {
            disabledColor.set()
        }
        
        var roundedRectanglePath: UIBezierPath!;
        switch cornerRadius {
        case .Half, .Quarter:
            let cornerRadiusValue = CGRectGetHeight(rect) / CGFloat(cornerRadius.intValue())
            roundedRectanglePath = UIBezierPath(roundedRect: btnRect, cornerRadius: cornerRadiusValue)
        case .Little:
            roundedRectanglePath = UIBezierPath(roundedRect: btnRect, cornerRadius: 5)
        default:
            roundedRectanglePath = UIBezierPath(rect: btnRect)
        }
        roundedRectanglePath.lineWidth = borderWidth
        roundedRectanglePath.fill()
        roundedRectanglePath.stroke()
        
        var titleSize = CGSizeZero
        var titleString = ""
        var titleRect = CGRectZero
        if let string = self.titleLabel?.text {
            titleString = string
            titleSize = string.stringSize([NSFontAttributeName : self.titleLabel!.font], size: rect.size)
            titleRect = CGRectMake((rect.width - titleSize.width) / 2, (rect.height - titleSize.height) / 2, titleSize.width, titleSize.height)
        }
        if let image = iconImage {
            let imageRatio = image.size.width / image.size.height
            var iconRect = CGRectZero
            switch iconImageStyle {
            case .Up:
                let iconWidth = rect.width * iconPercent
                let iconSize = CGSizeMake(iconWidth, iconWidth / imageRatio)
                iconRect = CGRectMake((rect.width - iconSize.width) / 2, iconMargin, iconSize.width, iconSize.height)
                titleRect = CGRectMake((rect.width - titleSize.width) / 2, iconRect.maxY, titleRect.width, titleRect.height)
            case .Left:
                let iconHeight = rect.height * iconPercent
                let iconSize = CGSizeMake(iconHeight * imageRatio, iconHeight)
                iconRect = CGRectMake(iconMargin, (rect.height - iconSize.height) / 2, iconSize.width, iconSize.height)
                titleRect = CGRectMake(iconRect.maxX + (rect.width - iconRect.maxX - titleSize.width) / 2, titleRect.origin.y, rect.width - iconRect.width - iconMargin, titleRect.height)
            case .Down:
                let iconWidth = rect.width * iconPercent
                let iconSize = CGSizeMake(iconWidth, iconWidth / imageRatio)
                iconRect = CGRectMake((rect.width - iconSize.width) / 2, rect.height - iconSize.height - iconMargin, iconSize.width, iconSize.height)
                titleRect = CGRectMake((rect.width - titleSize.width) / 2, iconRect.minY - titleRect.height, titleRect.width, titleRect.height)
            case .Right:
                let iconHeight = rect.height * iconPercent
                let iconSize = CGSizeMake(iconHeight * imageRatio, iconHeight)
                iconRect = CGRectMake(rect.width - iconSize.width - iconMargin, (rect.height - iconSize.height) / 2, iconSize.width, iconSize.height)
                titleRect = CGRectMake((rect.width - iconRect.width - titleRect.width - iconMargin) / 2, titleRect.origin.y, rect.width - iconRect.width - iconMargin, titleRect.height)
            }
            image.drawInRect(iconRect)
        }
        self.titleLabel?.alpha = 0.0
        NSString(string: titleString).drawInRect(titleRect, withAttributes: [
            NSFontAttributeName : self.titleLabel!.font,
            NSForegroundColorAttributeName: self.titleLabel!.textColor
            ])
    }
    override var highlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    override var enabled: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }

}
