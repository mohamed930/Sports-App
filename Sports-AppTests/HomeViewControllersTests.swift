//
//  HomeViewControllersTests.swift
//  Sports-AppTests
//
//  Created by Mohamed Ali on 3/27/21.
//

import XCTest
@testable import Sports_App

class HomeViewControllersTests: XCTestCase {
    
    var controller: HomeViewControllers!

    override func setUpWithError() throws {
        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewControllers")
        controller.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        controller = nil
    }
    
    func testGettingAPI () {
        
    }

}
