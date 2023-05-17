//
//  CountryService.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 13.05.2023.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case serverError
    case decodingError
}

class CountryService {
    
    var countriesByRegion: [String: [CountryModel]] = [:]
    
    enum RequestType {
        case allCountries
        case byCountryName(countryName: String)
    }
    
    enum APIType {
        case countries
        case byCountry
    }
    
    var onCompletionForCountry: (([CountryModel]) -> Void)?
    var onCompletionForAllCountry: ((Result<[String: [CountryModel]], NetworkError>) -> Void)?
    
    func fetchCountriesByType(forRequestType requestType: RequestType) {
        var urlString = ""
        var type: APIType
        
        switch requestType {
        case .allCountries:
            urlString = "https://restcountries.com/v3.1/all"
            type = .countries
            break
            
        case .byCountryName(let countryName):
            urlString = "https://restcountries.com/v3.1/alpha/\(countryName)"
            type = .byCountry
            break
        }
        
        performRequest(withUrlString: urlString, type: type)
    }
    
    fileprivate func performRequest(withUrlString urlString: String, type: APIType) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                switch type {
                case .countries:
                    if let currentData = self.parseJSONAllCountries(withdata: data) {
                        self.onCompletionForAllCountry?(.success(currentData))
                    } else {
                        self.onCompletionForAllCountry?(.failure(.decodingError))
                        print("error")
                    }
                    break
                case .byCountry:
                    if let currentData = self.parseJSONForSpecificCountry(withdata: data){
                        self.onCompletionForCountry?(currentData)
                    } else {
                        print("error2")
                    }
                    break
                }
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSONForSpecificCountry(withdata data: Data) -> [CountryModel]? {
        let decoder = JSONDecoder()
        do {
            let country = try decoder.decode([CountryModel].self, from: data)
            return country
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    fileprivate func parseJSONAllCountries(withdata data: Data) -> [String: [CountryModel]]? {
        let decoder = JSONDecoder()
        
        do {
            let countries = try decoder.decode([CountryModel].self, from: data)
            let getByRegions = self.distributeCountriesByRegion(countries)
            return getByRegions
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
    private func distributeCountriesByRegion(_ countries: [CountryModel]) -> [String: [CountryModel]] {
        
        for country in countries {
            if var regionCountries = countriesByRegion[country.continents[0].rawValue] {
                regionCountries.append(country)
                countriesByRegion[country.continents[0].rawValue] = regionCountries
            } else {
                countriesByRegion[country.continents[0].rawValue] = [country]
            }
        }
        return countriesByRegion
    }
}
