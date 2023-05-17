//
//  CalculateValues.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 16.05.2023.
//

import Foundation
import UIKit

class CalculateValues {
    
    func reducePopulationSize(value: Int) -> String {
        if value > 1000000 {
            return "\(value / 1000000) mln"
        }
        return "\(value)"
    }
    
    func reduceAreaSize(value: Double) -> String {
        return "\(value / 1000000) mln km\("²")"
    }
    
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func makeSkeleton() -> CountryModel {
        return CountryModel(name: Name(common: "", official: ""), cca2: "", currencies: nil, capital: nil, region: .africa, area: 0.0, flag: "", maps: Maps(googleMaps: "", openStreetMaps: ""), population: 0, timezones: [], continents: [.africa], flags: Flags(png: "", svg: "", alt: nil), capitalInfo: CapitalInfo(latlng: nil))
    }
}
