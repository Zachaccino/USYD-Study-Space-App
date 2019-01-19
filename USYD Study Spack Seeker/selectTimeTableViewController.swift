//
//  selectTimeTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 7/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class selectTimeTableViewController: UITableViewController {
    

    // MARK: Properties
    var usedFor = ""
    var selectedValue = 0
    var startTimeIfAvailable = 0
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    @IBAction func didNotSelect(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = usedFor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        saveButton.isEnabled = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usedFor == "Select Start Time" {
            return 13
        } else if usedFor == "Select End Time" {
            return 21 - startTimeIfAvailable
        } else {
            return 5
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "selectTimeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! selectTimeTableViewCell
        
        
        if usedFor == "Select Start Time" {
            cell.availableTimeCell.text = "\(indexPath.row + 8):00"
        } else if usedFor == "Select End Time" {
            cell.availableTimeCell.text = "\(indexPath.row + 1 + startTimeIfAvailable):00"
        } else {
            if indexPath.row == 0 {
                cell.availableTimeCell.text = "Monday"
            } else if indexPath.row == 1 {
                cell.availableTimeCell.text = "Tuesday"
            } else if indexPath.row == 2 {
                cell.availableTimeCell.text = "Wednesday"
            } else if indexPath.row == 3 {
                cell.availableTimeCell.text = "Thursday"
            } else if indexPath.row == 4 {
                cell.availableTimeCell.text = "Friday"
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        if usedFor == "Select Start Time" {
            selectedValue = index + 8
        } else if usedFor == "Select End Time" {
            selectedValue = index + 1 + startTimeIfAvailable
        } else {
            selectedValue = index
        }
        
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        
    }
    */
    
    

}
