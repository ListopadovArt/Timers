//
//  Task.swift
//  Timers
//
//  Created by Artem Listopadov on 3.04.22.
//

import Foundation

class Task {
    let name: String?
    let time: Int?
    
    init(name: String, time: Int) {
        self.name = name
        self.time = time
    }
}
