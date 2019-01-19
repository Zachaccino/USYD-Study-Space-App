//
//  myVenueTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 13/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class myVenueTableViewController: UITableViewController {
    
    var favouriteVenues = [String]()
    var favouriteVenuesSearchKey = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseUserFavouriteVenues()
        initialiseUserFavouriteVenuesSearchKey()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveUserFavouriteVenues()
        saveUserFavouriteVenuesSearchKey()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteVenues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "myVenueCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! myVenueTableViewCell

        cell.buildingLabel.text = favouriteVenues[indexPath.row]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoomsView" {
            let destView = segue.destination as! roomsTableViewController
            let cell = sender as! myVenueTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            destView.searchKey = favouriteVenuesSearchKey[indexPath!.row]
            destView.title = favouriteVenues[indexPath!.row]
        }
    }

    
    
    // MARK: Private Function.
    
    func initialiseUserFavouriteVenues() {
        if let data = UserDefaults.standard.value(forKey:"favouriteVenues") as? Data {
            favouriteVenues = try! PropertyListDecoder().decode([String].self, from: data)
        } else {
            favouriteVenues = [String]()
        }
    }
    
    
    func saveUserFavouriteVenues() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favouriteVenues), forKey:"favouriteVenues")
    }
    
    
    func initialiseUserFavouriteVenuesSearchKey() {
        if let data = UserDefaults.standard.value(forKey:"favouriteVenuesSearchKey") as? Data {
            favouriteVenuesSearchKey = try! PropertyListDecoder().decode([String].self, from: data)
        } else {
            favouriteVenuesSearchKey = [String]()
        }
    }
    
    
    func saveUserFavouriteVenuesSearchKey() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favouriteVenuesSearchKey), forKey:"favouriteVenuesSearchKey")
    }

    @IBAction func unwindToMyVenue(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? selectBuildingTableViewController {
            for venue in favouriteVenues {
                if venue == sourceViewController.selectedDisplayName {
                    return
                }
            }
            
            favouriteVenues.append(sourceViewController.selectedDisplayName)
            favouriteVenues.sort()
            
            favouriteVenuesSearchKey.append(sourceViewController.selectedSearchKey)
            favouriteVenuesSearchKey.sort()
            
            saveUserFavouriteVenues()
            saveUserFavouriteVenuesSearchKey()
            
            tableView.reloadData()
        }
    }
}
