# ios-takehome-project
Take-home project for prospective iOS devs!

Background
--------------------------
At DoorDash, we allow customers to order delivery from their favorite local restaurants. For this exercise, you will be building a ‘lite’ version of DoorDash. Users will be able to pick a location on a Map, and view a list of nearby stores.

Prerequisites
--------------------------

* Xcode 9.0+ and Swift 4.0+ support
* Custom scripts for [Carthage](https://github.com/Carthage/Carthage) 
* Custom scripts for [Alamofire](https://github.com/Alamofire/Alamofire)
* Custom scripts for [AlamofireImage](https://github.com/Alamofire/AlamofireImage)

* iOS Deployment Target -10.0

Installation
--------------------------

Install [Carthage](https://github.com/Carthage/Carthage):

`brew install carthage`
carthage update/bootstrap

Carthage is used as dependency manager by default.


Built with
--------------------------
CoreData - Used to save favorites.
MapKit - Showing location on the map with pin
Cartahge - Dependecy Management system


Features
--------------------------

When in use authorization on accessing Location.
Dropping the Pin on change of Location by dragging.
Based on the location, getting the list of restaurants.
Adding the restaurants in favorites list.


Unit Testing
--------------------------

Thsi app has unit test written for following classes
DoorDashViewModel
AddressViewController
ExploreViewController
FavoritesViewController

These tests are in the DoorDashTests group
To run the unit test, open DoorDash.xcodeproj, go to Product->Test

Author
--------------------------

Saurabh Anand,
saurabh2887@gmail.com
