//
//  ImageViewGroupViewController.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/7/7.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

private let reuseIdentifier = "customCell"
class ImageViewGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let items = ["CircleImageView", "CircleProgressImageView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSStringFromClass(CircleImageView)
        default:
            return ""
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellName = items[indexPath.section]
        if let view = NSBundle.mainBundle().loadNibNamed(cellName, owner: nil, options: nil)[0] as? UIView {
            return view.frame.height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as? ViewCell {
            let cellName = items[indexPath.section]
            if let view = NSBundle.mainBundle().loadNibNamed(cellName, owner: nil, options: nil)[0] as? UIView {
                cell.configureCell(view)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
