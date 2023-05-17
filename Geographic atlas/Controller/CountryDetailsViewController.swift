//
//  CountryDetailsViewController.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 15.05.2023.
//

import Foundation
import UIKit

class CountryDetailsViewController: UIViewController {
    
    private let regionCustomDetailView = CustomDetailView()
    private let capitalCustomDetailView = CustomDetailView()
    private let capitalCoorCustomDetailView = CustomDetailView()
    private let populationCustomDetailView = CustomDetailView()
    private let areaCustomDetailView = CustomDetailView()
    private let currencyCustomDetailView = CustomDetailView()
    private let timezonesCustomDetailView = CustomDetailView()
    
    let cacheImage = CachingImage()
    let calc = CalculateValues()
    let countryService = CountryService()
    
    lazy var contenViewSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 400)
    lazy private var userDefaults = UserDefaults.standard
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = contenViewSize
        sv.frame = self.view.bounds
        
        return sv
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenViewSize
        
        return view
    }()
    
    private lazy var countryImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updatInterface()
        constraintScrollView()
        addAllSubviews()
        setupCountryImage()
        setup()
        layout()
    }
    
    private func updatInterface() {
        if let code = userDefaults.object(forKey: "code") as? String {
            self.countryService.fetchCountriesByType(forRequestType: .byCountryName(countryName: code))
        }
        
        countryService.onCompletionForCountry = {[weak self] currentCity in
            guard let self = self else {return}
            self.updateInterfaceCell(country: currentCity)
        }
    }
    
    private func constraintScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func addAllSubviews() {
        contentView.addSubview(countryImage)
        contentView.addSubview(regionCustomDetailView)
        contentView.addSubview(capitalCustomDetailView)
        contentView.addSubview(capitalCoorCustomDetailView)
        contentView.addSubview(populationCustomDetailView)
        contentView.addSubview(areaCustomDetailView)
        contentView.addSubview(currencyCustomDetailView)
        contentView.addSubview(timezonesCustomDetailView)
    }
    
    private func setup() {
        regionCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        capitalCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        capitalCoorCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        populationCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        areaCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        currencyCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        timezonesCustomDetailView.translatesAutoresizingMaskIntoConstraints = false
        timezonesCustomDetailView.subTitle.numberOfLines = 0
        currencyCustomDetailView.subTitle.numberOfLines = 0
        regionCustomDetailView.title.text = "Region: "
        capitalCustomDetailView.title.text = "Capital: "
        capitalCoorCustomDetailView.title.text = "Capital coordinata: "
        populationCustomDetailView.title.text = "Population: "
        areaCustomDetailView.title.text = "Area: "
        currencyCustomDetailView.title.text = "Currency: "
        timezonesCustomDetailView.title.text = "Timezone: "
    }
    
    private func setupCountryImage() {
        countryImage.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40).isActive = true
        countryImage.heightAnchor.constraint(equalToConstant: view.frame.height / 3 - 60).isActive = true
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            countryImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            countryImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            countryImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            regionCustomDetailView.topAnchor.constraint(equalTo: countryImage.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            capitalCustomDetailView.topAnchor.constraint(equalTo: regionCustomDetailView.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            capitalCoorCustomDetailView.topAnchor.constraint(equalTo: capitalCustomDetailView.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            populationCustomDetailView.topAnchor.constraint(equalTo: capitalCoorCustomDetailView.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            areaCustomDetailView.topAnchor.constraint(equalTo: populationCustomDetailView.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            currencyCustomDetailView.topAnchor.constraint(equalTo: areaCustomDetailView.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            timezonesCustomDetailView.topAnchor.constraint(equalTo: currencyCustomDetailView.bottomAnchor, constant: 12)
        ])
    }
}

extension CountryDetailsViewController {
    func updateInterfaceCell(country: [CountryModel]) {
        
        DispatchQueue.main.async { [self] in
            if let flagURL = URL(string: country[0].flags.png) {
                cacheImage.loadImage(from: flagURL) { image in
                    guard let image = image else { return }
                    DispatchQueue.main.async { [self] in
                        self.countryImage.image = calc.resizeImage(image, to: CGSize(width: contentView.frame.width - 40, height: view.frame.height / 3 - 60))
                    }
                }
            }
            
            if let currenciesText = country[0].currencies?.compactMap({ (key, value) -> String? in
                return "\(value.name ?? "") (\(value.symbol ?? "")) (\(key))"
            }).joined(separator: "\n") {
                self.currencyCustomDetailView.subTitle.text = currenciesText
            }
            
            title = country[0].name.common
            regionCustomDetailView.subTitle.text = country[0].region.rawValue
            capitalCustomDetailView.subTitle.text = country[0].capital?[0]
            let capitalinfo = country[0].capitalInfo.latlng?.map{ ("\($0)") }.joined(separator: ", ")
            capitalCoorCustomDetailView.subTitle.text = capitalinfo
            populationCustomDetailView.subTitle.text = calc.reducePopulationSize(value: country[0].population)
            areaCustomDetailView.subTitle.text = calc.reduceAreaSize(value: country[0].area)
            let timezonesString = country[0].timezones.map { "\($0)\n" }.joined()
            timezonesCustomDetailView.subTitle.text = timezonesString
        }
    }
}
