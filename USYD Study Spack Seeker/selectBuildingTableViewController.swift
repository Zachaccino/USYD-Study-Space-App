//
//  selectBuildingTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 13/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class selectBuildingTableViewController: UITableViewController {
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let buildingData = Buildings()
    
    var buildingSearchKey = Buildings().buildingSearchKey
    
    var buildingDisplayName = Buildings().buildingDisplayName
    
    var selectedSearchKey = ""
    
    var selectedDisplayName = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buildingDisplayName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "selectBuildingCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! selectBuildingTableViewCell

        cell.buildingLabel.text = buildingDisplayName[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSearchKey = buildingSearchKey[indexPath.row]
        selectedDisplayName = buildingDisplayName[indexPath.row]
        saveButton.isEnabled = true
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

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
