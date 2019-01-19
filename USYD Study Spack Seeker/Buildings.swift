//
//  Buildings.swift
//  USYD Study Spack Seeker
//
//  Created by Zachaccino on 13/1/19.
//  Copyright © 2019 JingyuanTu. All rights reserved.
//

import Foundation

class Buildings {
    var buildingSearchKey: [String]
    var buildingDisplayName: [String]
    
    init() {
        buildingSearchKey = ["ABS",
                             "Aeronautical",
                             "Biochem",
                             "CPC",
                             "Carslaw",
                             "Chem Eng",
                             "Chemistry",
                             "Civil Eng",
                             "Eastern Avenue",
                             "Education Seminar",
                             "Elec Eng",
                             "Institute",
                             "Madsen",
                             "Mech Eng",
                             "Merewether",
                             "New Law",
                             "Nursing Seminar",
                             "PNR",
                             "SIT",
                             "Storie Dixson",
                             "Teachers College",
                             "Wilkinson"]
        
        buildingDisplayName = ["Abercrombie Building (ABS)",
                               "Aeronautical Building",
                               "Biochemisty Building",
                               "Charles Perkins Centre (CPC)",
                               "Carslaw Building",
                               "Chemical Engineering Building",
                               "Chemistry Building",
                               "Civil Engineering Building",
                               "Eastern Avenue",
                               "Education Building",
                               "Electrical Engineering Building",
                               "Institute Building",
                               "Madsen Building",
                               "Mechanical Engineering Building",
                               "Merewether Building",
                               "New Law Building",
                               "Nursing School",
                               "Peter Nicol Russell (PNR)",
                               "School of Computer Science (SCS)",
                               "Storie Dixson Building",
                               "Old Teachers College",
                               "Wilkinson Building"]
    }
}
