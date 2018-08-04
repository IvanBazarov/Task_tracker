//
//  StructOperation.swift
//  Task_tracker
//
//  Created by Иван Базаров on 25.07.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import UIKit

class StructOperation {
    struct globalArrays {
        static var namesArr = [String]()
        static var datesArr = [Date]()
        static var statusesArr = [String]()
        static var commentariesArr = [String]()
        static var statusesIntArr = [String]()
        
    }
    struct globalVars {
        static var name = String()
        static var date = Date()
        static var status = String()
        static var commentary = String()
        static var editing_started = Bool()
        static var index = Int()
        static var curr_status_row = Int()
    }
}
