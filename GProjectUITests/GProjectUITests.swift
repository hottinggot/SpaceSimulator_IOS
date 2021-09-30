//
//  GProjectUITests.swift
//  GProjectUITests
//
//  Created by 서정 on 2021/08/02.
//

import XCTest

class GProjectUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        XCUIApplication().launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let app = app2
        app.buttons["kakao login medium narrow"].tap()
        app.alerts["“GProject” Wants to Use “kakao.com” to Sign In"].scrollViews.otherElements.buttons["Continue"].tap()
        
        let app2 = app
        app2/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.textFields["KakaoMail ID, email, phone number"]/*[[".otherElements[\"BrowserView?WebViewProcessID=43353\"].webViews.webViews.webViews",".otherElements.matching(identifier: \"Log In\").textFields[\"KakaoMail ID, email, phone number\"]",".textFields[\"KakaoMail ID, email, phone number\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app2/*@START_MENU_TOKEN@*/.webViews.webViews.webViews.buttons["Log In"]/*[[".otherElements[\"BrowserView?WebViewProcessID=43353\"].webViews.webViews.webViews",".otherElements.matching(identifier: \"Log In\").buttons[\"Log In\"]",".buttons[\"Log In\"]",".webViews.webViews.webViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        
        let tablesQuery = app2.tables
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["햅삐"]/*[[".cells.staticTexts[\"햅삐\"]",".staticTexts[\"햅삐\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        app.buttons["수정"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        let textView = element.children(matching: .textView).element
        textView.tap()
        textView.tap()
        
        let button = app.buttons["저장"]
        button.tap()
        
        let button2 = app.navigationBars["게시글"].buttons["게시글"]
        button2.tap()
        staticText.tap()
        button2.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["changed"]/*[[".cells.staticTexts[\"changed\"]",".staticTexts[\"changed\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        button2.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hey !!"]/*[[".cells.staticTexts[\"Hey !!\"]",".staticTexts[\"Hey !!\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["삭제"].tap()
        app.buttons["글쓰기"].tap()
        element.tap()
        
        let textField = app.textFields["제목"]
        textField.tap()
        textField.tap()
        textView.tap()
        textView.tap()
        button.tap()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
