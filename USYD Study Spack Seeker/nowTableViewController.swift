//
//  nowTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by JingyuanTu on 17/12/18.
//  Copyright © 2018 JingyuanTu. All rights reserved.
//

import UIKit

class nowTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {

    // MARK: Properties
    var schedule = [String: [String: [String: String]]]()
    var thisWeek = String()
    var thisDay = String()
    var thisHour = String()
    var currentVenues = [VenueTime]()
    var isAfterHour = false
    
    // NEED TO BE CHANGED EVERY SEMESTER.
    var mid_sem_break = Int()
    var sem_starts = Date()
    
    // For search result.
    var searchResult = [VenueTime]()

    // For Sorting Rooms into Buildings
    var displayNames = Buildings().buildingDisplayName
    var searchKeys = Buildings().buildingSearchKey
    var correspondingVenues: [[VenueTime]] = []
    
    @IBAction func refreshTimetable(_ sender: Any) {
        schedule = [String: [String: [String: String]]]()
        thisWeek = String()
        thisDay = String()
        thisHour = String()
        currentVenues = [VenueTime]()
        isAfterHour = false
        searchResult = [VenueTime]()
        correspondingVenues = []
        
        loadSchedule()
        loadUnoccupiedVenues()
        distributeVenues()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Information.
        setupNavigationBar()
        loadSemesterInfo()
        loadSchedule()
        loadUnoccupiedVenues()
        distributeVenues()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return searchResult.count
        } else {
            return displayNames.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFiltering() {
            let cellID = "searchTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! nowTableViewCell
            cell.venueLabel.text = searchResult[indexPath.row].name
            cell.freeUntilLabel.text = searchResult[indexPath.row].phrase
            return cell
        } else {
            let cellID = "nowTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! nowTableViewCell
            cell.venueLabel.text = displayNames[indexPath.row]
            cell.freeUntilLabel.text = "\(countAvailable(givenVenues: correspondingVenues[indexPath.row])) rooms available."
            return cell
        }
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
        if segue.identifier == "ShowAvailableRoom" {
            let destView = segue.destination as! availableRoomsTableViewController
            let selectedCell = sender as! nowTableViewCell
            let indexPath = tableView.indexPath(for: selectedCell)
            destView.displayVenues = correspondingVenues[indexPath!.row]
        } else if segue.identifier == "ShowRoomSchedule" {
            let destView = segue.destination as! roomDetailTableViewController
            let selectedCell = sender as! nowTableViewCell
            destView.roomName = selectedCell.venueLabel.text!
        }
    }

    
    // MARK: Private Methods
    
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
      
        thisWeek = String(getWeekFromDate(date: today))
        thisDay = String(getDayFromDate(date: today))
        thisHour = String(getHourFromDate(date: today))
        
        if thisWeek == "-1" || thisDay == "-1" || thisHour == "-1" {
            isAfterHour = true
            return
        }
        
        // Generate the file name correspond to current week.
        let fileName = "occupied_" + thisWeek
        
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
    
    func loadUnoccupiedVenues() {
        // After hour
        if isAfterHour {
            currentVenues = [VenueTime(name: "Most venues are locked in after hours.", startTime: "Not Available", endTime: "is not available")]
            return
        }
        
        // Not after hour, Find the free venues.
        for (venue, daySchedule) in schedule {
            var freeUntil = -1
            
            for hour in Int(thisHour)!...20 {
                // Get the course that occupises the venue.
                let occupied_by = daySchedule[thisDay]![String(hour)] as Any as! String
                
                // Stop searching if it is not free.
                if occupied_by != "N/A" {
                    break
                }
                
                // Update the free time period.
                freeUntil = hour + 1
            }
            
            // Append an occupied room to array.
            if freeUntil != -1 {
                currentVenues.append(VenueTime(name: venue, startTime: "N/A", endTime: String(freeUntil) + ":00"))
            } else {
                let newVenue = VenueTime(name: venue, startTime: "N/A", endTime: String(freeUntil) + ":00")
                newVenue.setNotAvailable()
                currentVenues.append(newVenue)
            }
        }
        
        // Sort the venues.
        currentVenues = currentVenues.sorted(by: { $0.name < $1.name })
    }
    
    func setupNavigationBar() {
        // Set Navigation Bar Shadow.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search building or room."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: Search Bar Methods
    
    func searchWithInput(input: String) {
        // Reset the Array.
        searchResult = [VenueTime]()
        
        // Search.
        for item in currentVenues {
            let lowerCaseName = item.name.lowercased()
            let lowerCaseInputArr = input.lowercased().components(separatedBy: " ")
            var isSatisfy = true
            
            // Searching for each token.
            for index in 0..<lowerCaseInputArr.count {
                // Split keeps the space sometimes, so discard this empty token.
                if lowerCaseInputArr[index] == "" {
                    continue
                }
                
                // Matching token.
                if (lowerCaseName.range(of: lowerCaseInputArr[index]) == nil) {
                    isSatisfy = false
                    break
                }
            }
            
            // Only add the venues that satisfy with the input.
            if isSatisfy {
                searchResult.append(item)
            }
        }
        
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return navigationItem.searchController!.searchBar.text?.isEmpty ?? true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchWithInput(input: navigationItem.searchController!.searchBar.text ?? "")
    }
    
    func isFiltering() -> Bool {
        return navigationItem.searchController!.isActive && !searchBarIsEmpty()
    }
    
    func distributeVenues() {
        // Initialise Array
        correspondingVenues = []
        
        for _ in 0..<searchKeys.count {
            correspondingVenues.append([])
        }
        
        // Sorting into buildings.
        for item in currentVenues {
            for index in 0..<searchKeys.count {
                let searchKey = searchKeys[index]
                if (item.name.range(of: searchKey) != nil) {
                    correspondingVenues[index].append(item)
                }
            }
        }
    }
    
    func countAvailable(givenVenues:[VenueTime]) -> Int {
        var counter = 0
        
        for item in givenVenues {
            if (item.phrase.range(of: "Free until") != nil) {
                counter += 1
            }
        }
        
        return counter
    }
    
}
