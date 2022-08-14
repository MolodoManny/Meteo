//
//  SelfConfiguringCell.swift
//  Meteo
//
//  Created by Артем Савицкий on 14.08.2022.
//

import Foundation
import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier : String { get }
    func configure(with item  : ForecastTemperature)
}
