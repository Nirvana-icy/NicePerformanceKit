//
//  NPKitMetricsUITests.swift
//  NPKitDemo_ExampleUITests
//
//  Created by JinglongBi on 2021/10/20.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

import XCTest

class NPKitMetricsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let app = XCUIApplication()
//        app.launch()
//        
//        app.staticTexts["Slow Large Table"].tap()
//        let testTableView = app.tables.firstMatch
//        
//        let signpostMetric = self.signpostMetric(for: "scrollDraggingSignpost")
//        
//        let metrics: [XCTMetric]
//        if #available(iOS 14, *) {
//            metrics = [signpostMetric, XCTOSSignpostMetric.scrollDraggingMetric]
//        } else {
//            metrics = [signpostMetric]
//        }
//        
//        measure(metrics: metrics) {
//            testTableView.swipeDown(velocity: .fast)
//            startMeasuring()
//            testTableView.swipeUp(velocity: .fast)
//        }
//    }
    
    func testImageProcess_OriginImage() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Image Process Test"].tap()
        
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 1
        
        let memoryMetric = XCTMemoryMetric(application: app)
        let cpuMetric = XCTCPUMetric(application: app)
        let signpostMetric = self.signpostMetric(for: "testImageProcess")
        
        let metrics: [XCTMetric] = [memoryMetric, cpuMetric, signpostMetric]
//        if #available(iOS 14, *) {
//            memoryMetric = self.initWithProcessName(for: XCTMemoryMetric.self, processName: "XCMetrics")
//            cpuMetric = self.initWithProcessName(for: XCTCPUMetric.self, processName: "XCMetrics")
//        } else {
//            memoryMetric = XCTMemoryMetric(application: app)
//            cpuMetric = XCTCPUMetric(application: app)
//        }
        let processButton = app.buttons["Show Origin Image"]
        
        measure(metrics: metrics, options: measureOptions) {
            processButton.tap()
        }
    }
    
    func testImageProcess_ResizedImage() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.staticTexts["Image Process Test"].tap()
        
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 1
        
        let memoryMetric = XCTMemoryMetric(application: app)
        let cpuMetric = XCTCPUMetric(application: app)
        let signpostMetric = self.signpostMetric(for: "testImageProcess")
        let metrics: [XCTMetric] = [memoryMetric, cpuMetric, signpostMetric]
//        if #available(iOS 14, *) {
//            memoryMetric = self.initWithProcessName(for: XCTMemoryMetric.self, processName: "XCMetrics")
//            cpuMetric = self.initWithProcessName(for: XCTCPUMetric.self, processName: "XCMetrics")
//        } else {
//            memoryMetric = XCTMemoryMetric(application: app)
//            cpuMetric = XCTCPUMetric(application: app)
//        }
        let processButton = app.buttons["Show Resized Image"]
        
        measure(metrics: metrics, options: measureOptions) {
            processButton.tap()
        }
    }

    func testThreadsStorm() throws {
        let app = XCUIApplication()
        app.launch()
        
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 1
        
        let memoryMetric = XCTMemoryMetric(application: app)
        let cpuMetric = XCTCPUMetric(application: app)
        let metrics: [XCTMetric] = [memoryMetric, cpuMetric]
        
        measure(metrics: metrics, options: measureOptions) {
            app.buttons["Threads Storm Test"].tap()
        }
    }
    
    func testThreadsPool() throws {
        let app = XCUIApplication()
        app.launch()
        
        let measureOptions = XCTMeasureOptions()
        measureOptions.iterationCount = 1
        
        let memoryMetric = XCTMemoryMetric(application: app)
        let cpuMetric = XCTCPUMetric(application: app)
        let metrics: [XCTMetric] = [memoryMetric, cpuMetric]
        
        measure(metrics: metrics, options: measureOptions) {
            app.buttons["Async To Queue Pool"].tap()
        }
    }
    
    private func signpostMetric(for name: StaticString) -> XCTOSSignpostMetric {
        return XCTOSSignpostMetric(subsystem: "com.npk.metrics.test", category: "scrollOperations", name: String(describing: name))
    }
}
