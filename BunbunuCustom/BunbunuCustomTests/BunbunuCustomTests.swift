//
//  BunbunuCustomTests.swift
//  BunbunuCustomTests
//
//  Created by LEE ZHE YU on 2016/5/23.
//  Copyright © 2016年 LEE ZHE YU. All rights reserved.
//

@testable import BunbunuCustom
import XCTest

class BunbunuCustomTests: XCTestCase {
    var vc: ViewController?
    var buttonGroup: ButtonGroupViewController?
    var imageViewGroup: ImageViewGroupViewController?
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    override func setUp() {
        super.setUp()
        if let rootVC = storyboard.instantiateInitialViewController() as? UINavigationController {
            if let vc = rootVC.viewControllers.first as? ViewController {
                self.vc = vc
            }
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewControllerIdentifier() {
        guard let vc = vc else {
            XCTFail("Menu ViewController Nil")
            return
        }
        for identifier in vc.menu {
            if identifier.containsString("Button") {
                XCTAssertTrue(vc.menu.contains(identifier), "menu doesn'e include ButtonGroup")
                buttonGroup = storyboard.instantiateViewControllerWithIdentifier(identifier) as? ButtonGroupViewController
                XCTAssertNotNil(buttonGroup, "buttonGroup is Nil")
            }
            if identifier.containsString("ImageView") {
                XCTAssertTrue(vc.menu.contains(identifier), "menu doesn'e include ImageView")
                imageViewGroup = storyboard.instantiateViewControllerWithIdentifier(identifier) as? ImageViewGroupViewController
                XCTAssertNotNil(imageViewGroup, "ImageView is Nil")
            }
        }
    }
    
    func testButtonGroupViewIdentifier() {
        guard let vc = buttonGroup else {
            return
        }
        for identifer in vc.items {
            XCTAssertNotNil(NSBundle.mainBundle().loadNibNamed(identifer, owner: nil, options: nil)[0] as? UIView)
        }
    }
    
    func testImageViewGroupViewIdentifier() {
        guard let vc = imageViewGroup else {
            return
        }
        for identifer in vc.items {
            XCTAssertNotNil(NSBundle.mainBundle().loadNibNamed(identifer, owner: nil, options: nil)[0] as? UIView)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
