//
//  ExploreViewController.swift
//  DoorDash
//
//  Created by Saurabh Anand on 7/28/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

    var viewModel : DoorDashViewModel!

    @IBOutlet weak var exploreTableView: UITableView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchDoorDashDetails()
    }
    
    // MARK: - Fetch Door dash details
    /***************************************************************/
    
    //This function using longitude and latitude determined from map view and refesh the explore tab
    func fetchDoorDashDetails(){
        activityIndicatorView.isHidden = false;
        activityIndicatorView.startAnimating()
        
        viewModel.getDoorDashDetailsWithLattitudeAndLongitude() { (isSuccess,errorMsg ) in
            if isSuccess == true{
                
                if self.viewModel.exploreDoorDashList.count == 0{
                    self.showAlert(errorMsg: "No restaurants near by this locations.")
                }
                self.exploreTableView .reloadData()
            } else {
                self.showAlert(errorMsg: errorMsg)
            }
            self.activityIndicatorView.isHidden = true;
            self.activityIndicatorView.stopAnimating()

        }
    }
    
    // MARK: - Error Handling
    /***************************************************************/

    func showAlert(errorMsg: String) {
        let alert = UIAlertController(title: "Alert", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Table view data source and delegates
/***************************************************************/

extension ExploreViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.exploreDoorDashList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exploreDoorDashCell", for: indexPath) as! DoorDashTableViewCell
        
        cell.viewModel = viewModel
        cell.exploreDoorDash = viewModel.exploreDoorDashList[indexPath.row]

        return cell
    }
    
    //This is used to show Alert panel and call the method to add in the Favorites list when Add is clicked

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedDoordash = viewModel.exploreDoorDashList[indexPath.row]
        let alert = UIAlertController(title: "Add to Favorites", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.viewModel.addToFavorites(doorDash: selectedDoordash)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
