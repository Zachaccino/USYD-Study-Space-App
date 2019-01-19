//
//  roomDetailTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 16/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class roomDetailTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return selectorWeeks.count
        } else {
            return selectorDay.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return selectorWeeks[row]
        } else {
            return selectorDay[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedWeek = row + 1
        } else {
            selectedDay = row + 1
        }
    }

    
    @objc func doneSelect(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        thisWeek = selectedWeek
        thisDay = selectedDay        
        schedule = [String: [String: [String: String]]]()
        isAfterHour = false
        roomSchedule = [RoomSchedule]()
        
        loadSchedule()
        loadRoomSchedule()
        
        if isAfterHour {
            self.title = "Week \(thisWeek) After Hours Schedule"
        } else {
            self.title = "Week \(thisWeek) \(weekdayList[thisDay-1]) Schedule"
        }
        
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
    
    var roomName = ""
    
    var schedule = [String: [String: [String: String]]]()
    var thisWeek = -1
    var thisDay = -1
    var isAfterHour = false
    var weekdayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    var roomSchedule = [RoomSchedule]()
    
    var mid_sem_break = Int()
    var sem_starts = Date()
    
    @IBOutlet var textField: UITextField!
    var picker = UIPickerView()
    var selectorWeeks = ["Week 1", "Week 2", "Week 3", "Week 4", "Week 5", "Week 6", "Week 7", "Week 8", "Week 9", "Week 10", "Week 11", "Week 12", "Week 13"]
    var selectorDay = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    var selectedWeek = 1
    var selectedDay = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.dataSource = self
        picker.delegate = self
        navigationItem.largeTitleDisplayMode = .never

        loadSemesterInfo()
        
        if thisWeek == -1 || thisDay == -1 {
            loadWeek()
        }
        
        loadSchedule()
        loadRoomSchedule()
        
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
        
        if isAfterHour {
            self.title = "Week \(thisWeek) After Hours Schedule"
        } else {
             self.title = "Week \(thisWeek) \(weekdayList[thisDay-1]) Schedule"
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomSchedule.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "freeTimeCell", for: indexPath) as! roomDetailTableViewCell
        
        cell.timeLabel.text = roomSchedule[indexPath.row].timePhrase
        cell.occupiedLabel.text = roomSchedule[indexPath.row].occupiedBy
        cell.roomLabel.text = roomName

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Private Functions
    func loadSemesterInfo() {
        // Configure semester start date.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        sem_starts = dateFormatter.date(from: "2018 7 30")!
        
        // Configure mid sem break.
        mid_sem_break = 9
    }
    
    func loadWeek(){
        let today = Date()
        
        thisWeek = getWeekFromDate(date: today)
        thisDay = getDayFromDate(date: today)
        
        if thisWeek == -1 || thisDay == -1 {
            isAfterHour = true
            return
        }
    }
    
    func loadSchedule() {
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
    
    func loadRoomSchedule() {
        if isAfterHour {
            roomSchedule.append(RoomSchedule(occupiedBy: "No schedule during after hours.", timePhrase: ""))
            return
        }
        
        var startTime = -1
        var endTime = -1
        var occupiedBy = ""
        var scheduleList: [ScheduleItem] = []
        
        print(thisDay)
        for item in schedule[roomName]![String(thisDay)]! {
            scheduleList.append(ScheduleItem(time: Int(item.key)!, course: item.value))
        }
        
        scheduleList = scheduleList.sorted(by: { $0.time < $1.time })
        
        
        for item in scheduleList {
            let time = item.time
            let course = item.course
            
            if startTime == -1 {
                startTime = time
                occupiedBy = course
            } else if occupiedBy != course {
                endTime = time
                if occupiedBy == "N/A" {
                    roomSchedule.append(RoomSchedule(occupiedBy: "Unoccupied", timePhrase: "\(startTime):00 - \(endTime):00"))
                } else {
                    roomSchedule.append(RoomSchedule(occupiedBy: "\(occupiedBy)", timePhrase: "\(startTime):00 - \(endTime):00"))
                }
                
                startTime = time
                occupiedBy = course
                endTime = -1
            }
            
            if time == 20 {
                endTime = 21
                if occupiedBy == "N/A" {
                    roomSchedule.append(RoomSchedule(occupiedBy: "Unoccupied", timePhrase: "\(startTime):00 - \(endTime):00"))
                } else {
                    roomSchedule.append(RoomSchedule(occupiedBy: "\(occupiedBy)", timePhrase: "\(startTime):00 - \(endTime):00"))
                }
            }
        }
    }
}
