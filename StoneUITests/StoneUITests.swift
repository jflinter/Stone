//
//  StoneUITests.swift
//  StoneUITests
//
//  Created by Jack Flintermann on 8/21/16.
//  Copyright © 2016 Stone. All rights reserved.
//

import XCTest

extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}

class StoneUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testSnapshots() {
        
        let app = XCUIApplication()
        app.navigationBars["Stone.CrystalCollectionView"].images["Stone-Logo-Icon"].tap()
        
        snapshot("0Grid")
        
        app.navigationBars["Stone.CrystalCollectionView"].buttons["Search"].tap()
        
        app.otherElements["search segmented control"].tap()
        
        let crystalSearchBarElement = app.otherElements["crystal search bar"]
        let searchField = crystalSearchBarElement.children(matching: .searchField).element
        searchField.tap()
        searchField.typeText("moldav")
        
        let collectionView = app.collectionViews["crystal collection view"]
        collectionView.children(matching: .cell).element(boundBy: 0).children(matching: .image).element.forceTapElement()
        
        snapshot("1Moldavite")
        
        app.buttons["icon close"].tap()
        
        searchField.tap()
        searchField.typeText(XCUIKeyboardKeyDelete)
        searchField.typeText(XCUIKeyboardKeyDelete)
        searchField.typeText(XCUIKeyboardKeyDelete)
        searchField.typeText(XCUIKeyboardKeyDelete)
        searchField.typeText(XCUIKeyboardKeyDelete)
        searchField.typeText(XCUIKeyboardKeyDelete)
        searchField.typeText("apoph")
        
        collectionView.children(matching: .cell).element(boundBy: 0).children(matching: .image).element.forceTapElement()
        snapshot("2Apophyllite")
        
        
        
//        XCUIDevice.sharedDevice().orientation = .FaceUp
//        
//        let app = XCUIApplication()
//        snapshot("Grid")
//        app.navigationBars["Stone.CrystalCollectionView"].buttons["Search"].tap()
//        
//        let element2 = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
//        let collectionView = element2.childrenMatchingType(.CollectionView).element
//        collectionView.tap()
//        
//        let element = element2.childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).elementBoundByIndex(2)
//        element.childrenMatchingType(.SearchField).element
//        
//        let image = collectionView.childrenMatchingType(.Cell).elementBoundByIndex(0).childrenMatchingType(.Image).element
//        image.tap()
//        snapshot("Moldavite")
//        app.buttons["icon close"].tap()
//        element.childrenMatchingType(.SearchField).element.tap()
//        
//        let deleteKey = app.keys["delete"]
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        deleteKey.tap()
//        element.childrenMatchingType(.SearchField).element
//        image.tap()
//        snapshot("Apophyllite")
        
    }
    
}
