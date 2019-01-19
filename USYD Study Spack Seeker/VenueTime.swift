//
//  venueTime.swift
//  USYD Study Spack Seeker
//
//  Created by JingyuanTu on 18/12/18.
//  Copyright © 2018 JingyuanTu. All rights reserved.
//

import Foundation

class VenueTime {
    var name: String
    var startTime: String
    var endTime: String
    var phrase: String
    
    init(name: String, startTime: String, endTime: String) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.phrase = "Free until " + self.endTime + "."
    }
    
    func setNotAvailable() {
        self.phrase = "Not available."
    }
    
    func setNoAvailableTimeSlot() {
        self.phrase = "No available time slot."
    }
    
    func setNextAvailable() {
        self.phrase = "Next available time is \(startTime) - \(endTime)"
    }
    
    func setAfterHour() {
        self.phrase = "Not available during after hours."
    }
}
