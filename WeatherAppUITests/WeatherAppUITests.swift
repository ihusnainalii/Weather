//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Amir on 1/17/21.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    // NOTE: for UI tests to work the keyboard of simulator must be on.
    // Keyboard shortcut COMMAND + SHIFT + K while simulator has focus
    // Please make sure your keyboard is english
    func testIfUIAtFirstLaunchWorks() {
        let app = XCUIApplication()
        
        if !LocationManager.shared.isLocationEnabled() {
            XCTAssert(app.alerts["Allow “WeatherApp” to use your location?"].waitForExistence(timeout: 10))
            app.alerts["Allow “WeatherApp” to use your location?"].scrollViews.otherElements.buttons["Allow While Using App"].tap()
        }
        
        XCTAssert(app.buttons["gearshape"].waitForExistence(timeout: 0.1))
        app.buttons["gearshape"].tap()
        
        let addButton = app.buttons["add"]
        XCTAssert(addButton.exists)
        addButton.tap()
                
        let tKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        
        let hKey = app/*@START_MENU_TOKEN@*/.keys["h"]/*[[".keyboards.keys[\"h\"]",".keys[\"h\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        hKey.tap()
        
        let rKey = app/*@START_MENU_TOKEN@*/.keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let nKey = app/*@START_MENU_TOKEN@*/.keys["n"]/*[[".keyboards.keys[\"n\"]",".keys[\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        nKey.tap()
        
        XCTAssert(app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["Tehran"]/*[[".cells.staticTexts[\"Tehran\"]",".staticTexts[\"Tehran\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 10))
        app.tables/*@START_MENU_TOKEN@*/.cells.staticTexts["Tehran"]/*[[".cells.staticTexts[\"Tehran\"]",".staticTexts[\"Tehran\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        XCTAssert(app.tables.cells.staticTexts["Tehran"].waitForExistence(timeout: 5.0))
        app.navigationBars["Your Cities"].buttons["Back"].tap()
        
    }
    
    func findEnglishKeyboard(app: XCUIApplication) {
        if app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
            return
        } else {
            let nextKeyboardButton = app.buttons["Next keyboard"]
            nextKeyboardButton.tap()
            findEnglishKeyboard(app: app)
        }
    }
}
#if DEBUG
func printIfDebug(_ string: String) {
    print(string)
}
#endif
