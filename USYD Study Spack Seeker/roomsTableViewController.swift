//
//  roomsTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 14/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class roomsTableViewController: UITableViewController {
    
    var schedule = [String: [String: [String: String]]]()
    var thisWeek = -1
    var thisDay = -1
    var thisHour = -1
    var isAfterHour = false
    
    var searchKey = ""
    var venues = [VenueTime]()
    
    var mid_sem_break = Int()
    var sem_starts = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSemesterInfo()
        loadSchedule()
        loadVenues()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as! roomsTableViewCell

        cell.venueLabel.text = venues[indexPath.row].name
        cell.nextAvailableLabel.text = venues[indexPath.row].phrase

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
        if segue.identifier == "ShowRoomDetail" {
            let destView = segue.destination as! roomDetailTableViewController
            let selectedCell = sender as! roomsTableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
            destView.roomName = venues[indexPath!.row].name
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
    
    func loadSchedule() {
        let today = Date()

        thisWeek = getWeekFromDate(date: today)
        thisDay = getDayFromDate(date: today)
        thisHour = getHourFromDate(date: today)
        
        if thisWeek == -1 || thisDay == -1 || thisHour == -1 {
            isAfterHour = true
            return
        }
        
        // Generate the file name correspond to current week.
        let fileName = "occupied_\(thisWeek)"
        
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
        if rawWeek < 1 || rawWeek > 14 || rawWeek == mid_sem_break {
            return -1
        } else if rawWeek < mid_sem_break {
            return rawWeek
        }
        
        return rawWeek - 1
    }
    
    func getDayFromDate(date: Date) -> Int {
        // Get the week day with sunday as first day.
        let calendar = Calendar(identifier: .gregorian)
        let weekDay = calendar.component(.weekday, from: date) - 1
        
        if weekDay == 0 || weekDay == 6 {
            return -1
        }
        
        return weekDay
    }
    
    func getHourFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        if hour < 8 || hour > 20 {
            return -1
        }
        
        return hour
    }
    
    func loadVenues() {
        // Not after hour, Find the free venues.
        for (venue, daySchedule) in schedule {
            
            if (venue.range(of: searchKey) == nil) {
                continue
            }
            
            var earliestStart = thisHour
            var freeUntil = -1
            var isCounting = false
            
            for hour in thisHour...20 {
                // Get the course that occupises the venue.
                let occupied_by = daySchedule[String(thisDay)]![String(hour)] as Any as! String
                
                // Stop searching if it is not free.
                if occupied_by != "N/A" && !isCounting {
                    earliestStart = hour + 1
                    continue
                } else if occupied_by != "N/A" && isCounting {
                    break
                }
                
                // Update the free time period.
                isCounting = true
                freeUntil = hour + 1
            }
            
            if isAfterHour {
                let newVenue = VenueTime(name: venue, startTime: "N/A", endTime: "N/A")
                newVenue.setAfterHour()
                venues.append(newVenue)
            } else {
                // Append an occupied room to array.
                if freeUntil == -1 {
                    let newVenue = VenueTime(name: venue, startTime: "N/A", endTime: "N/A")
                    newVenue.setNoAvailableTimeSlot()
                    venues.append(newVenue)
                } else {
                    let newVenue = VenueTime(name: venue, startTime: "\(earliestStart):00", endTime: "\(freeUntil):00")
                    
                    if earliestStart != thisHour {
                        newVenue.setNextAvailable()
                    }
                    
                    venues.append(newVenue)
                }
            }
        }
        
        // Sort the venues.
        venues = venues.sorted(by: { $0.name < $1.name })
    }
    
}
