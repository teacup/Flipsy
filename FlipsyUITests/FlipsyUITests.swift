//
//  FlipsyUITests.swift
//  FlipsyUITests
//
//  Created by DotVC on 19/04/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import XCTest

class FlipsyUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFlipPhoto() {
        XCUIDevice.shared.orientation = .portrait
        let image = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .image).element
        
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .image).element.tap()
        XCTAssertTrue(image.exists)
    }
    
    func testSavePhoto() {
        XCUIDevice.shared.orientation = .portrait
        
        let _ = app.images["mainPhoto"]
        app.buttons["icon flip"].tap()
        app.toolbars.buttons["icon save4"].tap()
        let monitor = addUIInterruptionMonitor(withDescription: "Photo save notification") { (alert) -> Bool in
            if alert.buttons["Modify"].exists {
                alert.buttons["Modify"].tap()
                return true
            }
            return false
        }
        removeUIInterruptionMonitor(monitor)
        app.tap()
        
        // Test with save label
        let labelElement = app.staticTexts["Saved"]
        XCTAssertTrue(labelElement.exists)
    }
    
    func testTakePhoto() {
        XCUIDevice.shared.orientation = .portrait
        
        app.toolbars.buttons["icon camera3"].tap()
        app.buttons["icon flip camera2"].tap()
        app.buttons["take photo"].tap()
    }
    
    func testTakePhotoAndSave() {
        XCUIDevice.shared.orientation = .portrait
        
        app.toolbars.buttons["icon camera3"].tap()
        app.buttons["icon flip camera2"].tap()
        app.buttons["take photo"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).tap()
    }
    
}
