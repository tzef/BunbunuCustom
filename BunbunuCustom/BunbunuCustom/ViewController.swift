//
//  ViewController.swift
//  BunbunuCustom
//
//  Created by LEE ZHE YU on 2016/5/22.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

import UIKit

private let reuseIdentifier = "basicCell"
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let menu = ["Button"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(index, animated: true)
        }
    }
    
    // MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vcName = menu[indexPath.row]
        if let vc = storyboard?.instantiateViewControllerWithIdentifier(vcName) {
            self.showViewController(vc, sender: nil)
        }
    }
}

