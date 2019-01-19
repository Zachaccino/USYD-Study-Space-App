//
//  addNewTimeTableViewController.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 6/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import UIKit

class addNewTimeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    // MARK: Properties
    var selectedStartTime = -1
    var selectedEndTime = -1
    var weekday = -1
    var weekdayList = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    
    // For Use in Setting the table view un-interactable.
    var originalTimeLabelColor: UIColor? = nil
    var originalSnippedLabelColor: UIColor? = nil
    
    var selectedTime: Time?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var selectorDays = ["Mon", "Tue", "Wed", "Thur", "Fri"]
    var selectorChosenWeek = 0
    var selectorChosenStart = 8
    var selectorChosenEnd = 9
    var picker = UIPickerView()
    
    
    // MARK: Action
    
    @IBAction func didNotSave(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        picker.dataSource = self
        picker.delegate = self
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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "AddNewTimeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! addNewTimeTableViewCell

        let index = indexPath.row
        
        if index == 1 {
            cell.timeSnippetLabel.text = "Starts"
            
            if selectedStartTime == -1 {
                cell.selectedTimeLabel.text = "Not set."
            } else {
                cell.selectedTimeLabel.text = "\(selectedStartTime):00"
            }
        } else if index == 2 {
            cell.timeSnippetLabel.text = "Ends"
            
            if selectedEndTime == -1 {
                cell.selectedTimeLabel.text = "Not set."
            } else {
                cell.selectedTimeLabel.text = "\(selectedEndTime):00"
            }
            
        } else {
            cell.timeSnippetLabel.text = "Weekday"
            
            if weekday == -1 {
                cell.selectedTimeLabel.text = "Not set."
            } else {
                cell.selectedTimeLabel.text = "\(weekdayList[weekday])"
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
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
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            return
        }
        
        selectedTime = Time(startTime: selectedStartTime, endTime: selectedEndTime)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 5
        } else if component == 1 {
            return 13
        } else if component == 2 {
            return 1
        } else {
            return 21 - selectorChosenStart
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return selectorDays[row]
        } else if component == 1 {
            return "\(row + 8):00"
        } else if component == 2 {
            return "to"
        } else {
            return "\(row + 1 + selectorChosenStart):00"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectorChosenWeek = row
        } else if component == 1 {
            selectorChosenStart = row + 8
            pickerView.reloadAllComponents()
            let rowOfComponent = pickerView.selectedRow(inComponent: 3)
            selectorChosenEnd = rowOfComponent + 1 + selectorChosenStart
            
        } else if component == 3 {
            selectorChosenEnd = row + 1 + selectorChosenStart
        }
        pickerView.reloadAllComponents()
    }
    
    
    @objc func doneSelect(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        weekday = selectorChosenWeek
        selectedStartTime = selectorChosenStart
        selectedEndTime = selectorChosenEnd
        saveButton.isEnabled = true
        tableView.reloadData()
        
    }
    
    @objc func cancel(sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
}
