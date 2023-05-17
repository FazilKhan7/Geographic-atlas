//
//  CountryModel.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 13.05.2023.
//

import Foundation
import UIKit

struct CountryModel: Codable {
    let name: Name
    let cca2: String
    let currencies: [String: Currencies]?
    let capital: [String]?
    let region: Region
    let area: Double
    let flag: String
    let maps: Maps
    let population: Int
    let timezones: [String]
    let continents: [Continent]
    let flags: Flags
    let capitalInfo: CapitalInfo
}

// MARK: - Currencies
struct Currencies: Codable {
    let name: String?
    let symbol: String?
}

// MARK: - Continent
enum Continent: String, Codable {
    case africa = "Africa"
    case antarctica = "Antarctica"
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "North America"
    case oceania = "Oceania"
    case southAmerica = "South America"
}

// MARK: - Flags
struct Flags: Codable {
    let png: String
    let svg: String
    let alt: String?
}

// MARK: - Maps
struct Maps: Codable {
    let googleMaps, openStreetMaps: String
}

// MARK: - Name
struct Name: Codable {
    let common, official: String
}

enum Region: String, Codable {
    case africa = "Africa"
    case americas = "Americas"
    case antarctic = "Antarctic"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
}

struct CapitalInfo: Codable {
    let latlng: [Double]?
}

typealias Welcome = [CountryModel]
