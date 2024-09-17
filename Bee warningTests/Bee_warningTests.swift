////
////  Bee_warningTests.swift
////  FireBee warningTests
////
////  Created by Moutaz Baaj on 29.06.24.
////
//
// import XCTest
// import FirebaseFirestore
// import FirebaseAuth
// import CoreLocation
// @testable import Bee_warning
//
// class BeeViewModelTests: XCTestCase {
//
//    var viewModel: BeeViewModel!
//
//    override func setUpWithError() throws {
//        // Set up the view model before each test
//        viewModel = BeeViewModel.shared
//    }
//
//    override func tearDownWithError() throws {
//        // Clean up after each test
//        viewModel = nil
//    }
//    
//    func testFetchBees() throws {
//        // Arrange
//        let expectation = self.expectation(description: "fetching bees")
//        
//        // Act
//        viewModel.fetchBees()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            // Assert
//            XCTAssertFalse(self.viewModel.bees.isEmpty, "Bee reports should be fetched and populated")
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 3.0)
//    }
//
// }
