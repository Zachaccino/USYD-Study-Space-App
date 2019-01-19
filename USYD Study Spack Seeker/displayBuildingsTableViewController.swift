//
//  displayBuildingsTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 10/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class displayBuildingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    // MARK: Properties
    var week = -1
    var day = -1
    var startTime = -1
    var endTime = -1
    
    var weekdayList = ["Mon", "Tue", "Wed", "Thur", "Fri"]
    
    var schedule = [String: [String: [String: String]]]()
    var currentFreeVenues = [[VenueTime]]()
    var currentUnavailableVenues = [[VenueTime]]()
    var displayVenues = [[VenueTime]]()
    
    // NEED TO BE CHANGED EVERY SEMESTER.
    var mid_sem_break = Int()
    var sem_starts = Date()
    
    let buildingData = Buildings()
    
    var buildingSearchKey = Buildings().buildingSearchKey
    
    var buildingDisplayName = Buildings().buildingDisplayName
    
    @IBOutlet var textField: UITextField!
    
    var picker = UIPickerView()
    var selectorWeeks = ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8", "Week 9",
                         "Week 10", "Week 11", "Week 12", "Week 13"]
    var selectedWeek = 1
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectorWeeks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return selectorWeeks[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedWeek = row + 1
    }
    
    
    @objc func doneSelect(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        week = selectedWeek
        loadSchedule()
        loadRooms()
        self.title = "Week \(week) \(weekdayList[day]) \(startTime) to \(endTime)"
        tableView.reloadData()
    }
    
    @objc func cancel(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
    
    @IBAction func showWeekDaySelector(_ sender: UIBarButtonItem) {
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        
        //navigationItem.largeTitleDisplayMode = .never
        loadSemesterInfo()
        loadWeek()
        initialiseArray()
        loadSchedule()
        loadRooms()
        
        picker.backgroundColor = UIColor.white
        textField.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(doneSelect(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancel(sender:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
        //self.title = "Buildings on Week \(week)"
        self.title = "Week \(week) \(weekdayList[day]) \(startTime) to \(endTime)"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buildingSearchKey.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "displayBuildingCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! buildingNameTableViewCell
        
        cell.buildingNameLabel.text = buildingDisplayName[indexPath.row]
        
        if currentFreeVenues[indexPath.row].count == 0 {
            cell.availabilityLabel.text = "No available Rooms."
        } else {
            cell.availabilityLabel.text = "\(currentFreeVenues[indexPath.row].count) available rooms."
        }
        
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
        if segue.identifier == "ShowAvailableRoomsView" {
            let destView = segue.destination as! availableRoomsTableViewController
            let selectedCell = sender as! buildingNameTableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
  
            destView.displayVenues = displayVenues[indexPath!.row]
            destView.selectedWeek = week
            destView.selectedDay = day+1
        }
    }

    
    // MARK: Private Functions
    func loadSemesterInfo() {
        // Configure semester start date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        sem_starts = dateFormatter.date(from: "2018 7 30")!
        
        // Configure mid sem break.
        mid_sem_break = 9
    }
    
    func getWeekFromDate(date: Date) -> Int {
        // Configure data formatter.
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        
        // Find the start of each date.
        let startDate = calendar.startOfDay(for: sem_starts)
        let targetDate = calendar.startOfDay(for: date)
        
        // Differences in days.
        let diffDays = calendar.dateComponents([.day], from: startDate, to: targetDate)
        
        let rawWeek = Int(ceil((Double(diffDays.day!)+0.1)/7))
        
        // Return the timetabled week. Mid sem break and non existing week return -1.
        
        if rawWeek < 1 {
            return 1
        } else if rawWeek > 14 {
            return 13
        } else if rawWeek == mid_sem_break {
            return mid_sem_break - 1
        } else if rawWeek < mid_sem_break {
            return rawWeek
        }
        
        return rawWeek - 1
    }
    
    func loadWeek() {
        let today = Date()
        week = getWeekFromDate(date: today)
    }
    
    func initialiseArray() {
        currentFreeVenues = [[VenueTime]]()
        currentUnavailableVenues = [[VenueTime]]()
        displayVenues = [[VenueTime]]()
        
        for _ in 0..<buildingSearchKey.count {
            currentUnavailableVenues.append([])
            currentFreeVenues.append([])
            displayVenues.append([])
        }
    }
    
    func loadSchedule() {
        // Generate the file name correspond to current week.
        let fileName = "occupied_\(week)"
        // Convert JSON String to Dictionary.
        // Retrieve File URL within bundle.
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                // Read JSON String from file in UTF-8 Standard.
                let jsonString = try String(contentsOfFile: path, encoding: .utf8).data(using: .utf8)!
                
                // Force Casting the Generic type to dictionary with optional value.
                if let weeklyData = try JSONSerialization.jsonObject(with: jsonString, options: []) as? [String: [String: [String: String]]] {
                    schedule = weeklyData
                }
                
                // Pretend I'm handling Errors.
            } catch {
                print("This Absolute Nightmare has happened again.")
                return
            }
        }
    }
    
    func loadRooms() {
        
        initialiseArray()

        // Not after hour, Find the free venues.
        for (venue, daySchedule) in schedule {
            
            var searchKeyIndex = 0
            
            for index in 0..<buildingSearchKey.count {
                if (venue.range(of: buildingSearchKey[index]) != nil) {
                    searchKeyIndex = index
                }
            }
            
            var freeUntil = -1
            
            for hour in startTime...20 {
                // Get the course that occupises the venue.
                let occupied_by = daySchedule["\(day + 1)"]!["\(hour)"] as Any as! String
                
                // Stop searching if it is not free.
                if occupied_by != "N/A" {
                    break
                }
                
                // Update the free time period.
                freeUntil = hour + 1
            }
            
            // Append an occupied room to array.
            if freeUntil != -1 && freeUntil >= endTime {
                currentFreeVenues[searchKeyIndex].append(VenueTime(name: venue, startTime: "N/A", endTime: String(freeUntil) + ":00"))
            } else {
                let newVenueTime = VenueTime(name: venue, startTime: "N/A", endTime: "N/A")
                newVenueTime.setNotAvailable()
                
                currentUnavailableVenues[searchKeyIndex].append(newVenueTime)
            }
            
        }
        
        for index in 0..<buildingSearchKey.count {
            displayVenues[index] = currentFreeVenues[index] + currentUnavailableVenues[index]
        }
        
    }
}
