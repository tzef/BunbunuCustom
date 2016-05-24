//
//  FilterButtonView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

private let reuseIdentifier = "filterCell"
class ToggleButtonView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ToggleButtonCellProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    var filterArray = [
        ("icon_list_like", "LIKE", false),
        ("icon_list_web", "WEB", false),
        ("icon_list_text", "TEXT", false),
        ("icon_list_namecard", "NAME CARD", false),
        ("icon_list_position", "POSITION", false),
        ("icon_list_email", "E-MAIL", false),
        ("icon_list_sms", "SMS", false),
        ("icon_list_phone", "PHONE", false)
    ]
    
    override func awakeFromNib() {
        collectionView.registerClass(ToggleButtonCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: Delegate
    func chageFlagSatus(item: (String, String, Bool)) {
        filterArray = filterArray.map({ (icon: String, title: String, flag: Bool) -> (String, String, Bool) in
            var mapItem = (icon, title, flag)
            if title == item.1 {
                mapItem.2 = !flag
            }
            return mapItem
        })
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let (_, title, _) = filterArray[indexPath.row]
        let size = title.stringSize([NSFontAttributeName: UIFont.systemFontOfSize(15)], size: CGSizeZero)
        return CGSize(width: 60 + size.width, height: 44)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ToggleButtonCell {
            cell.configureCell(filterArray[indexPath.row])
            cell.delegate = self
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

protocol ToggleButtonCellProtocol: class {
    func chageFlagSatus(item: (String, String, Bool))
}
class ToggleButtonCell: UICollectionViewCell {
    weak var delegate: ToggleButtonCellProtocol?
    func configureCell(item: (icon: String, title: String, flag: Bool)) {
        let size = item.title.stringSize([NSFontAttributeName: UIFont.systemFontOfSize(15)], size: CGSizeZero)
        let button = ToggleButton(flag: item.flag, icon: UIImage(named: item.icon), title: item.title) {
            self.delegate?.chageFlagSatus(item)
        }
        button.frame = CGRectMake(0, 7, 60 + size.width, 30)
        for v in self.contentView.subviews {
            v.removeFromSuperview()
        }
        self.contentView.addSubview(button)
    }
}
