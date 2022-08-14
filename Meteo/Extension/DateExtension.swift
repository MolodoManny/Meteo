//
//  DateExtension.swift
//  Meteo
//
//  Created by Артем Савицкий on 14.08.2022.
//


import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
