//
//  Extensions.swift
//  DaliyW
//
//  Created by Mammademin Muzaffarli on 10/5/17.
//  Copyright © 2017 Mammademin Muzaffarli. All rights reserved.
//

import Foundation
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
}
