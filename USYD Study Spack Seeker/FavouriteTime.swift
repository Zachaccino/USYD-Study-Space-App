//
//  favouriteTime.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 4/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import Foundation

struct Time: Codable {
    var startTime: Int
    var endTime: Int
}

struct RoomSchedule: Codable {
    var occupiedBy: String
    var timePhrase: String
}

struct ScheduleItem: Codable {
    var time: Int
    var course: String
}

struct FavouriteTime: Codable {
    var monday: [Time]
    var tuesday: [Time]
    var wednesday: [Time]
    var thursday: [Time]
    var friday: [Time]
    var saturday: [Time]
    var sunday: [Time]
}
