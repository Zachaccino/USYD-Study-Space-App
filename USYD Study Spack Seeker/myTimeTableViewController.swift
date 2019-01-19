//
//  myTimeTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 4/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class myTimeTableViewController: UITableViewController {
    
    // MARK: Properties
    var favouriteTime: FavouriteTime?
    //var selectedRow = -1
    //var selectedSection = -1
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        initialiseUserFavouriteTime()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveUserFavouriteTime()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return favouriteTime!.monday.count
        } else if section == 1 {
            return favouriteTime!.tuesday.count
        } else if section == 2 {
            return favouriteTime!.wednesday.count
        } else if section == 3 {
            return favouriteTime!.thursday.count
        } else {
            return favouriteTime!.friday.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "timeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! myTimeTableViewCell
        
        let section = indexPath.section
        let index = indexPath.row
        var startTime = 0
        var endTime = 0
        
        if section == 0 {
            startTime = favouriteTime!.monday[index].startTime
            endTime = favouriteTime!.monday[index].endTime
        } else if section == 1 {
            startTime = favouriteTime!.tuesday[index].startTime
            endTime = favouriteTime!.tuesday[index].endTime
        } else if section == 2 {
            startTime = favouriteTime!.wednesday[index].startTime
            endTime = favouriteTime!.wednesday[index].endTime
        } else if section == 3 {
            startTime = favouriteTime!.thursday[index].startTime
            endTime = favouriteTime!.thursday[index].endTime
        } else {
            startTime = favouriteTime!.friday[index].startTime
            endTime = favouriteTime!.friday[index].endTime
        }
   
        cell.timeLabel.text = "\(startTime):00 - \(endTime):00"
        
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
        if segue.identifier == "ShowBuildingView" {
            let destView = segue.destination as! displayBuildingsTableViewController
            let selectedCell = sender as! myTimeTableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
            let selectedSection = indexPath!.section
            let selectedRow = indexPath!.row
            
            destView.day = indexPath!.section
            
            if selectedSection == 0 {
                destView.startTime = favouriteTime!.monday[selectedRow].startTime
                destView.endTime = favouriteTime!.monday[selectedRow].endTime
            } else if selectedSection == 1 {
                destView.startTime = favouriteTime!.tuesday[selectedRow].startTime
                destView.endTime = favouriteTime!.tuesday[selectedRow].endTime
            } else if selectedSection == 2 {
                destView.startTime = favouriteTime!.wednesday[selectedRow].startTime
                destView.endTime = favouriteTime!.wednesday[selectedRow].endTime
            } else if selectedSection == 3 {
                destView.startTime = favouriteTime!.thursday[selectedRow].startTime
                destView.endTime = favouriteTime!.thursday[selectedRow].endTime
            } else if selectedSection == 4 {
                destView.startTime = favouriteTime!.friday[selectedRow].startTime
                destView.endTime = favouriteTime!.friday[selectedRow].endTime
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && favouriteTime!.monday.count != 0 {
            return "Monday"
        } else if section == 1 && favouriteTime!.tuesday.count != 0 {
            return "Tuesday"
        } else if section == 2 && favouriteTime!.wednesday.count != 0 {
            return "Wednesday"
        } else if section == 3 && favouriteTime!.thursday.count != 0 {
            return "Thursday"
        } else if section == 4 && favouriteTime!.friday.count != 0 {
            return "Friday"
        } else {
            return nil
        }
    }
    
    
    // MARK: Private Function.
    
    func initialiseUserFavouriteTime() {
        if let data = UserDefaults.standard.value(forKey:"favouriteTime") as? Data {
            favouriteTime = try? PropertyListDecoder().decode(FavouriteTime.self, from: data)
        } else {
            favouriteTime = FavouriteTime(monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [], sunday: [])
        }
    }
    
    
    func saveUserFavouriteTime() {
        sortFavouriteTime()
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favouriteTime), forKey:"favouriteTime")
    }
    
    
    func isTimeExist(allTimes: [Time], input: Time) -> Bool {
        for item in allTimes {
            if item.startTime == input.startTime && item.endTime == input.endTime {
                return true
            }
        }
        
        return false
    }
    
    
    @IBAction func unwindToMyTime(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? addNewTimeTableViewController, let selectedTime = sourceViewController.selectedTime {

            let weekday = sourceViewController.weekday
            
            if weekday == 0 {
                if !isTimeExist(allTimes: favouriteTime!.monday, input: selectedTime) {
                    favouriteTime!.monday.append(selectedTime)
                    saveUserFavouriteTime()
                    tableView.reloadData()
                }
            } else if weekday == 1 {
                if !isTimeExist(allTimes: favouriteTime!.tuesday, input: selectedTime) {
                    favouriteTime!.tuesday.append(selectedTime)
                    saveUserFavouriteTime()
                    tableView.reloadData()
                }
            } else if weekday == 2 {
                if !isTimeExist(allTimes: favouriteTime!.wednesday, input: selectedTime) {
                    favouriteTime!.wednesday.append(selectedTime)
                    saveUserFavouriteTime()
                    tableView.reloadData()
                }
            } else if weekday == 3 {
                if !isTimeExist(allTimes: favouriteTime!.thursday, input: selectedTime) {
                    favouriteTime!.thursday.append(selectedTime)
                    saveUserFavouriteTime()
                    tableView.reloadData()
                }
            } else if weekday == 4 {
                if !isTimeExist(allTimes: favouriteTime!.friday, input: selectedTime) {
                    favouriteTime!.friday.append(selectedTime)
                    saveUserFavouriteTime()
                    tableView.reloadData()
                }
            }
            return
        }
    }
    
    func comparator(_ s1: Time, _ s2: Time) -> Bool {
        if s1.startTime == s2.startTime {
            if s1.endTime < s2.endTime {
                return true
            } else {
                return false
            }
        } else if s1.startTime < s2.startTime {
            return true
        } else {
            return false
        }
    }
    
    func sortFavouriteTime() {
        favouriteTime!.monday.sort(by: comparator)
        favouriteTime!.tuesday.sort(by: comparator)
        favouriteTime!.wednesday.sort(by: comparator)
        favouriteTime!.thursday.sort(by: comparator)
        favouriteTime!.friday.sort(by: comparator)
        favouriteTime!.saturday.sort(by: comparator)
        favouriteTime!.sunday.sort(by: comparator)
    }

}
