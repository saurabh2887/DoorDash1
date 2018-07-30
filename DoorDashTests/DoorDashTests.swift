//
//  DoorDashTests.swift
//  DoorDashTests
//
//  Created by Saurabh Anand on 7/29/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import UIKit
import XCTest
import MapKit

@testable import DoorDash

//MARK: - DoorDashViewModel test case implementation
/***************************************************************/

class DoorDashTests: XCTestCase {
    
    var testViewModel: DoorDashViewModel!
    
    override func setUp() {
        super.setUp()
        
        testViewModel = DoorDashViewModel()
        testViewModel.latitude = 50.068
        testViewModel.longitude = -5.316
        
    }
    
    override func tearDown() {
        testViewModel = nil
        super.tearDown()
    }
    
    func test_getDoorDashDetailsWithLattitudeAndLongitude(){
        
        var isFetched = false
        let expectation = self.expectation(description: "DoorDash")

        testViewModel.getDoorDashDetailsWithLattitudeAndLongitude { (isSuccess, errorMsg) in
            if isSuccess{
                isFetched = true
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(isFetched)
    }
    
    func test_fetchImage(){
        
        var isFetched = false
        let expectation = self.expectation(description: "Image")

        let imageURL = "https://cdn.doordash.com/media/restaurant/cover/Tommy-Thai.png"
        testViewModel.fetchImage(imageURL: imageURL) { (Image, errorMsg) in
            if errorMsg.count == 0{
                isFetched = true
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertTrue(isFetched)
    }
    
    func test_populateDoorDashDetails(){
        
        let response = [["id":1443,
                         "name":"N1 - Pad Thai",
                         "description":"Canadian bacon & pineapple.",
                         "delivery_fee":0,
                         "asap_time":36,
                         "cover_img_url":"https://cdn.doordash.com/media/restaurant/cover/Tommy-Thai.png"]]
        
        testViewModel.populateDoorDashDetails(responseData: response)
        
        XCTAssertFalse(testViewModel.exploreDoorDashList.count == 0)
    }
    
    func test_addToFavorites(){
        
        let exploreModel = ExploreDoorDashModel()
        exploreModel.id = 1443
        exploreModel.name = "N1 - Pad Thai"
        exploreModel.storeDescription = "Canadian bacon & pineapple."
        exploreModel.deliveryFee = 299
        exploreModel.asapTime = 45
        exploreModel.coverImageURL = "https://cdn.doordash.com/media/restaurant/cover/Tommy-Thai.png"
        
        testViewModel.addToFavorites(doorDash: exploreModel)
        
        XCTAssertFalse(testViewModel.favoritesDoorDashList.count == 0)
    }
    
    func test_removeFromFavorites(){
        
        test_addToFavorites()
        testViewModel.removeFromFavorites(index: 0)
        XCTAssertFalse(testViewModel.favoritesDoorDashList.count > 0)
    }
    
}

//MARK: - AddressViewController test case implementation
/***************************************************************/

class AddressViewControllerTests: XCTestCase {
    
    var testAddressViewController : AddressViewController!

    override func setUp() {
        super.setUp()
        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        testAddressViewController = storyboard.instantiateInitialViewController() as! AddressViewController
        
        //load view hierarchy
        if(testAddressViewController != nil) {
            testAddressViewController.loadView()
            testAddressViewController.viewDidLoad()
            
        }
    }
    
    override func tearDown() {
        testAddressViewController = nil
        super.tearDown()
    }
    
    func test_ViewControllerIsComposedOfMapView() {
        
        XCTAssertNotNil(testAddressViewController.mapKitOutlet, "AddressViewController is not composed of a MKMapView")
    }
    
    func test_ControllerConformsToMKMapViewDelegate() {
        
        XCTAssert(testAddressViewController.conforms(to: MKMapViewDelegate.self), "AddressViewController does not conform to MKMapViewDelegate protocol")
    }
    
    func test_MapViewDelegateIsSet() {
        
        XCTAssertNotNil(testAddressViewController.mapKitOutlet.delegate)
    }
    
    func test_MapInitialization() {
        
        XCTAssert(testAddressViewController.mapKitOutlet.mapType == MKMapType.standard);
    }
    
    func test_ControllerImplementsDidUpdateUserLocation() {
        
        XCTAssert(testAddressViewController.responds(to: #selector(AddressViewController.mapView(_:didUpdate:))), "AddressViewController does not implement mapView:didUpdate")
    }
    
    func test_ControllerImplementsMKMapViewDelegateMethods() {
        
        XCTAssert(testAddressViewController.responds(to: #selector(AddressViewController.mapView(_:viewFor:))), "AddressViewController does not implement mapView:viewForAnnotation")
    }
    
    func test_ControllerImplementsRegionDidChange() {
        
        XCTAssert(testAddressViewController.responds(to: #selector(AddressViewController.mapView(_:regionDidChangeAnimated:))), "AddressViewController does not implement mapView:regionDidChangeAnimated")
    }
    
    func test_updatePinLocation(){
        let coordinate = CLLocationCoordinate2D(latitude: 37.42274, longitude: -122.139956)
        testAddressViewController.updatePinLocation(coordinate: coordinate)
    }
    
    func test_displayAddress(){
        let coordinate = CLLocationCoordinate2D(latitude: 37.42274, longitude: -122.139956)
        testAddressViewController.displayAddress(coordinate: coordinate)
        XCTAssertFalse(testAddressViewController.addressLabelOutlet.text?.count == 0)
    }
    
//    func test_performSegue(){
//        testAddressViewController.performSegue(withIdentifier: "goToDoorDashList", sender: self)
//    }
}

//MARK: - ExploreViewController test case implementation
/***************************************************************/

class ExploreViewControllerTests: XCTestCase {
    
    var testExploreViewController : ExploreViewController!
    
    override func setUp() {
        super.setUp()
        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        testExploreViewController = storyboard.instantiateViewController(withIdentifier: "Explore") as! ExploreViewController
        
        let testViewModel = DoorDashViewModel()
        testViewModel.latitude = 50.068
        testViewModel.longitude = -5.316
        testExploreViewController.viewModel = testViewModel
        
        //load view hierarchy
        if(testExploreViewController != nil) {
            testExploreViewController.loadView()
            testExploreViewController.viewDidLoad()
        }
    }
    
    override func tearDown() {
        testExploreViewController = nil
        super.tearDown()
    }
    
    func test_ViewControllerIsComposedOfTableView() {
        
        XCTAssertNotNil(testExploreViewController.exploreTableView, "ExploreViewController is not composed of a UITableView")
    }
    
    func test_ControllerConformsToTableViewDelegate() {
        
        XCTAssert(testExploreViewController.conforms(to: UITableViewDelegate.self), "ExploreViewController does not conform to UITableViewDelegate protocol")
    }
    
    func test_UITableViewDelegateIsSet() {
        
        XCTAssertNotNil(testExploreViewController.exploreTableView.delegate)
    }
    
    func test_ControllerImplementsDidCreateCellForRow() {
        
        XCTAssert(testExploreViewController.responds(to: #selector(ExploreViewController.tableView(_:cellForRowAt:))), "AddressViewController does not implement tableView:cellForRowAt")
    }
    
    func test_ControllerImplementsDidSelectRow() {
        
        XCTAssert(testExploreViewController.responds(to: #selector(ExploreViewController.tableView(_:didSelectRowAt:))), "AddressViewController does not implement tableView:didSelectRowAt")
    }

}

//MARK: - FavoritesViewController test case implementation
/***************************************************************/

class FavoritesViewControllerTests: XCTestCase {
    var testFavoritesViewController : FavoritesViewController!
    
    override func setUp() {
        super.setUp()
        //get the storyboard the ViewController under test is inside
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        //get the ViewController we want to test from the storyboard (note the identifier is the id explicitly set in the identity inspector)
        testFavoritesViewController = storyboard.instantiateViewController(withIdentifier: "Favorites") as! FavoritesViewController
        
        let testViewModel = DoorDashViewModel()
        testFavoritesViewController.viewModel = testViewModel
        
        let exploreModel = ExploreDoorDashModel()
        exploreModel.id = 1443
        exploreModel.name = "N1 - Pad Thai"
        exploreModel.storeDescription = "Canadian bacon & pineapple."
        exploreModel.deliveryFee = 299
        exploreModel.asapTime = 45
        exploreModel.coverImageURL = "https://cdn.doordash.com/media/restaurant/cover/Tommy-Thai.png"
        
        testViewModel.addToFavorites(doorDash: exploreModel)
        
        //load view hierarchy
        if(testFavoritesViewController != nil) {
            testFavoritesViewController.loadView()
            testFavoritesViewController.viewDidLoad()
        }
    }
    
    override func tearDown() {
        testFavoritesViewController = nil
        super.tearDown()
    }
    
    func test_ViewControllerIsComposedOfTableView() {
        
        XCTAssertNotNil(testFavoritesViewController.favoritesTableView, "ExploreViewController is not composed of a UITableView")
    }
    
    func test_ControllerConformsToTableViewDelegate() {
        
        XCTAssert(testFavoritesViewController.conforms(to: UITableViewDelegate.self), "FavoritesViewController does not conform to UITableViewDelegate protocol")
    }
    
    func test_UITableViewDelegateIsSet() {
        
        XCTAssertNotNil(testFavoritesViewController.favoritesTableView.delegate)
    }
    
    func test_ControllerImplementsDidCreateCellForRow() {
        
        XCTAssert(testFavoritesViewController.responds(to: #selector(FavoritesViewController.tableView(_:cellForRowAt:))), "FavoritesViewController does not implement tableView:cellForRowAt")
    }
    
    func test_ControllerImplementsDidSelectRow() {
        
        XCTAssert(testFavoritesViewController.responds(to: #selector(FavoritesViewController.tableView(_:didSelectRowAt:))), "FavoritesViewController does not implement tableView:didSelectRowAt")
    }
}

