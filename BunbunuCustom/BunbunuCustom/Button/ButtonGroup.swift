//
//  ButtonGroup.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

class ButtonGroup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let identifierCell = "customCell"
    let cells = ["StyleButtonView"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSStringFromClass(StyleButton)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellName = cells[indexPath.row]
        if let view = NSBundle.mainBundle().loadNibNamed(cellName, owner: nil, options: nil)[0] as? UIView {
            return view.frame.height
        } else {
            return tableView.estimatedRowHeight
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifierCell, forIndexPath: indexPath) as? ViewCell {
            let cellName = cells[indexPath.row]
            if let view = NSBundle.mainBundle().loadNibNamed(cellName, owner: nil, options: nil)[0] as? UIView {
                cell.configureCell(view)
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

class ViewCell: UITableViewCell {
    func configureCell(view: UIView) {
        view.frame = self.contentView.frame
        self.contentView.addSubview(view)
    }
}