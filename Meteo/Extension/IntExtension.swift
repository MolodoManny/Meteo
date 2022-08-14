//
//  IntExtension.swift
//  Meteo
//
//  Created by Артем Савицкий on 14.08.2022.
//


import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
