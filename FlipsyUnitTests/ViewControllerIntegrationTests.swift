//
//  ViewControllerIntegrationTests.swift
//  Flipsy
//
//  Created by DotVC on 03/05/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import XCTest

class ViewControllerIntegrationTests: XCTestCase {
    
    var vc: MainViewController!
    var waitExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        setupViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Helper functions
    func setupViewController() {
        let bundle = Bundle(for: type(of: self))
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        _ = vc.view
        vc.childView?.reloadAssets()
        wait(2)
    }
    
    func wait(_ duration: TimeInterval) {
        waitExpectation = expectation(description: "wait")
        Timer.scheduledTimer(timeInterval: duration, target: self,
                             selector: #selector(flipsyUnitTests.onTimer), userInfo: nil, repeats: false)
        waitForExpectations(timeout: duration, handler: nil)
    }
    
    func onTimer() {
        waitExpectation?.fulfill()
    }
    
    // MARK: Tests
    func testMainImageLoads() {
        let loadedMainImage = vc.imageView?.image
        XCTAssert(loadedMainImage != nil, "Main image loaded")
    }
    
    func testImageFlipsOnTap() {
        let loadedMainImage = vc.imageView?.image
        let initialOrientation = loadedMainImage?.imageOrientation.rawValue
        vc.flipImage()
        let flipped = vc.imageView?.image?.imageOrientation.rawValue
        
        XCTAssertTrue(initialOrientation == 0 && flipped == 4)
    }
    
    func testFlippedImageSaves() {
        let expect = expectation(description: "Save image")
        var photoState: PhotoSaveState = .UnSaved("")
        
        func afterSave(_ state: PhotoSaveState) {
            photoState = state
            expect.fulfill()
        }
        
        vc.flipImage()
        vc.saveMyImage(then: afterSave)
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(photoState == PhotoSaveState.Saved)
    }
    
}
