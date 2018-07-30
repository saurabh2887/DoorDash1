//
//  DoorDashTableViewCell.swift
//  DoorDash
//
//  Created by Saurabh Anand on 7/28/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import UIKit

class DoorDashTableViewCell: UITableViewCell {

    @IBOutlet weak var icon : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : UILabel!
    @IBOutlet weak var deliveryPriceLabel : UILabel!
    @IBOutlet weak var deliveryTimeLabel : UILabel!
    
    var viewModel : DoorDashViewModel!

    var exploreDoorDash : ExploreDoorDashModel? {
        didSet {
            setExploreData()
        }
    }
    
    var favoritesDoorDash : DoorDashModel? {
        didSet {
            setFavoritesData()
        }
    }
    
    //MARK: - Set Explore tab
    /***************************************************************/

    // This function sets the labels in prototype cells in Explore tab screen
    func setExploreData(){
        if let dd = exploreDoorDash{
            titleLabel.text = dd.name
            descriptionLabel.text = dd.storeDescription
            if dd.deliveryFee == 0{
                deliveryPriceLabel.text = "Free delivery"
            } else {
                let fee : Double = Double(dd.deliveryFee)/100
                deliveryPriceLabel.text = "$\(fee) delivery"
            }
            deliveryTimeLabel.text = "\(dd.asapTime) min"
            
            fetchImagefromURL(imageURL: dd.coverImageURL)
        }
    }

    //MARK: - Set Favorites tab
    /***************************************************************/

    // This function sets the labels in prototype cells in Favorites tab screen
    func setFavoritesData(){
        if let dd = favoritesDoorDash{
            titleLabel.text = dd.name
            descriptionLabel.text = dd.storeDescription
            if dd.deliveryFee == 0{
                deliveryPriceLabel.text = "Free delivery"
            } else {
                let fee : Double = Double(dd.deliveryFee)/100
                deliveryPriceLabel.text = "$\(fee) delivery"
            }
            deliveryTimeLabel.text = "\(dd.asapTime) min"
            
            fetchImagefromURL(imageURL: dd.coverImageURL!)

        }
    }
    
    //MARK: - Get Image using image URL
    /***************************************************************/
    
    /// This function returns a image for a given image URL.
    ///
    ///
    /// Usage:
    ///
    ///     This method is used to fetch image and save it to cookie when already fetched.
    ///     Set the icon outlet image
    ///
    /// - Parameter imageURL: fetched from doordash details and is passed over to fetch image
    ///
    /// - Returns: UIImage and Error Message as String
    
    func fetchImagefromURL(imageURL: String){
        viewModel.fetchImage(imageURL: imageURL) { (image, errorMsg) in
            DispatchQueue.main.async {
                self.icon.image = image
            }
        }
    }
}
