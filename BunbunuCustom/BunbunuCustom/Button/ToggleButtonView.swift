//
//  FilterButtonView.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

private let reuseIdentifier = "filterCell"
class ToggleButtonView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    let filterArray = [
        ("icon_list_like", "LIKE"),
        ("icon_list_web", "WEB"),
        ("icon_list_text", "TEXT"),
        ("icon_list_namecard", "NAME CARD"),
        ("icon_list_position", "POSITION"),
        ("icon_list_email", "E-MAIL"),
        ("icon_list_sms", "SMS"),
        ("icon_list_phone", "PHONE")
    ]
    
    override func awakeFromNib() {
        collectionView.registerClass(ButtonCell.classForCoder(), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let (_, title) = filterArray[indexPath.row]
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
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ButtonCell {
            cell.configureCell(filterArray[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

class ButtonCell: UICollectionViewCell {
    func configureCell(item: (icon: String, title: String)) {
        let size = item.title.stringSize([NSFontAttributeName: UIFont.systemFontOfSize(15)], size: CGSizeZero)
        let button = ToggleButton(flag: false, icon: UIImage(named: item.icon), title: item.title, clickClosure: nil)
        button.frame = CGRectMake(0, 7, 60 + size.width, 30)
        for v in self.contentView.subviews {
            v.removeFromSuperview()
        }
        self.contentView.addSubview(button)
    }
}
