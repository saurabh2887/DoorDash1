//
//  DoorDashViewModel.swift
//  DoorDash
//
//  Created by Saurabh Anand on 7/28/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Alamofire
import AlamofireImage

class DoorDashViewModel {
    
    var exploreDoorDashList = [ExploreDoorDashModel]()
    
    var favoritesDoorDashList = [DoorDashModel]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var latitude : Double?
    var longitude : Double?
    
    //Constants
    let baseURL = "https://api.doordash.com/"
    
    var httpHeaders : [String:String] = ["Content-Type" : "application/json", "Accept": "application/json"]
    
    //MARK: - Get Door Dash Details using Longitude and Latitude
    /***************************************************************/
    
    /// This function returns a DoorDash Details for a given longitude and latitude.
    ///
    ///
    /// Usage:
    ///
    ///     This method is used to fetch door dash details by using longitude and latitude as parameters
    ///
    /// - Parameter latitude: Latitude passed from MKMapView.
    /// - Parameter longitude: Longitude passed from MKMapView.
    ///
    /// - Returns: DoorDash Details as Array of DoorDash Model and Error Message as String
    
    func getDoorDashDetailsWithLattitudeAndLongitude(completionHandler: @escaping (Bool,String) -> Void) {
        
        let url = "\(baseURL)v1/store_search/?lat=\(latitude ?? 0.0)&lng=\(longitude ?? 0.0)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: httpHeaders).responseJSON { (response) in
            if response.result.isSuccess{
                
                print(response.result.value!)
                if let responseData = response.result.value! as? [[String:Any]]{
                    
                    self.populateDoorDashDetails(responseData: responseData)
                    completionHandler(true,"")
                } else {
                    completionHandler(false,(response.error?.localizedDescription)!)
                }
            } else{
                completionHandler(false,(response.error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: - Get Image using image URL
    /***************************************************************/
    
    /// This function returns a image for a given image URL.
    ///
    ///
    /// Usage:
    ///
    ///     This method is used to fetch image and save it to cookie when already fetched
    ///
    /// - Parameter imageURL: fetched from doordash details and is passed over to fetch image
    ///
    /// - Returns: UIImage and Error Message as String
    
    func fetchImage(imageURL: String, completionHandler: @escaping (UIImage,String) -> Void) {
        Alamofire.request(imageURL).responseImage { (response) in
            if response.result.isSuccess{
                if let image = response.result.value {
                    completionHandler(image,"")
                } else {
                    completionHandler(UIImage(),(response.error?.localizedDescription)!)
                }
            } else {
                completionHandler(UIImage(),(response.error?.localizedDescription)!)
            }
        }
    }
    
    
    //MARK: - Populate the exploreDoorDashList for Explore tab
    /***************************************************************/
    
    /// This function populates exploreDoorDashList array to load Explore tab.
    ///
    ///
    /// Usage:
    ///
    ///     This method is used to populate exploreDoorDashList array to load Explore screen.
    ///
    /// - Parameter responseData: fetched from doordash details and is passed over to populate exploreDoorDashList array
    
    func populateDoorDashDetails (responseData : [[String:Any]]){
        
        for item in responseData{
            let doorDashDetail = ExploreDoorDashModel()
            
            if let doorDashID = item["id"]  as? Int {
                doorDashDetail.id = doorDashID
            }
            if let name = item["name"]  as? String {
                doorDashDetail.name = name
            }
            if let storeDesc = item["description"]  as? String {
                doorDashDetail.storeDescription = storeDesc
            }
            if let delivFee = item["delivery_fee"]  as? Int {
                doorDashDetail.deliveryFee = delivFee
            }
            if let deliveryTime = item["asap_time"]  as? Int {
                doorDashDetail.asapTime = deliveryTime
            }
            if let imageURL = item["cover_img_url"]  as? String {
                doorDashDetail.coverImageURL = imageURL
            }
            
            exploreDoorDashList.append(doorDashDetail)
        }
    }
    
    
    //MARK: - Core Data methods
    /***************************************************************/
    
    /// This function adds to the favoritesDoorDashList array to load Favorites tab
    ///
    ///
    /// Usage:
    ///
    ///     This method is used to add to the favorites list and save it to the core data.
    ///     It will first check in favoritesDoorDashList array, if the new data is already added in the list.
    ///
    /// - Parameter doorDash: passed from ExploreViewController to add to the favorites screen
    
    func addToFavorites(doorDash: ExploreDoorDashModel) {
        
        let ind = favoritesDoorDashList.index { (doordashModel) -> Bool in
            if doordashModel.id == doorDash.id{
                return true
            }
            return false
        }
        
        if ind == nil || favoritesDoorDashList.count == 0{
            let newDoorDash = DoorDashModel(context: context)
            
            newDoorDash.id = Int64(doorDash.id)
            newDoorDash.name = doorDash.name
            newDoorDash.deliveryFee = Int64(doorDash.deliveryFee)
            newDoorDash.asapTime = Int64(doorDash.asapTime)
            newDoorDash.coverImageURL = doorDash.coverImageURL
            newDoorDash.storeDescription = doorDash.storeDescription
            
            favoritesDoorDashList.append(newDoorDash)
            
            saveContext()
        }
    }
    
    
    /// This function adds to the favoritesDoorDashList array to load Favorites tab
    ///
    ///
    /// Usage:
    ///
    ///     This method is used to remove from the favorites list and context, save it to the core data.
    ///     It will first check if index passed should be less than favoritesDoorDashList.count
    ///
    /// - Parameter index: passed from FavoritesViewController to remove from the Favorites tab
    
    func removeFromFavorites(index: Int) {
        if index < favoritesDoorDashList.count{
            context.delete(favoritesDoorDashList[index])
            favoritesDoorDashList.remove(at: index)
            saveContext()
        }
    }
    
    // Fetching the data from persistent container for favorites
    func fetchItem(){
        let request: NSFetchRequest<DoorDashModel> = DoorDashModel.fetchRequest()
        
        do {
            favoritesDoorDashList = try context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
    }
    
    // saving the favorites in manageobject context and then save to persistent layer
    func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            } catch{
                print("Error in saving context \(error)")
                
            }
        }
    }
    
}
