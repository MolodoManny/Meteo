//
//  KelvinToCelciusConverter.swift
//  Meteo
//
//  Created by Артем Савицкий on 14.08.2022.
//

import Foundation
import UIKit

extension Float {
    func truncate(places : Int) -> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func kelvinToCelciusConverter() -> Float {
        let constatVal : Float = 273.15
        let keValue = self
        let celValue = keValue - constatVal
        return celValue.truncate(places: 1)
    }
}
