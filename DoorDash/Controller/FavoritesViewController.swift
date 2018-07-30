//
//  FavoritesViewController.swift
//  DoorDash
//
//  Created by Saurabh Anand on 7/28/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    var viewModel : DoorDashViewModel!

    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Fetch the favorites list from core data
        viewModel.fetchItem()
        
        // Refresh the table view
        favoritesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoritesTableView.reloadData()
    }
}

//MARK: - Table view data source and delegates
/***************************************************************/

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritesDoorDashList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesDoorDashCell", for: indexPath) as! DoorDashTableViewCell
        
        cell.viewModel = viewModel
        cell.favoritesDoorDash = viewModel.favoritesDoorDashList[indexPath.row]
        
        return cell
    }
    
    //This is used to show Alert panel and call the method to remove from the Favorites list when Remove is clicked

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Remove from Favorites", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Remove", style: .default) { (action) in
            self.viewModel.removeFromFavorites(index: indexPath.row)
            self.favoritesTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
