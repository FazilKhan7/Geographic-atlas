//
//  CountriesListViewController.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 12.05.2023.
//

import Foundation
import UIKit

class CountriesListViewController: UIViewController {
    
    let countryService = CountryService()
    var sections: [Section] = []
    let userDefaults = UserDefaults.standard
    var isLoaded = false
    
    override func viewDidLoad() {
        setupCollectionView()
        addAllSubviews()
        setup()
        layout()
        updateInterface()
        title = "World Countries"
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(CountryCell.self, forCellWithReuseIdentifier: CountryCell.reuseId)
        collectionView.register(CustomSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomSectionHeaderView.headerResuseId)
        collectionView.register(SkeletonCell.self, forCellWithReuseIdentifier: SkeletonCell.reuseID)
        
        setupSkeletons()
    }
    
    private func updateInterface() {
        self.countryService.fetchCountriesByType(forRequestType: .allCountries)
        
        countryService.onCompletionForAllCountry = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let countries):
                self.isLoaded = true
                let continents = Array(Set(countries.keys))
                let sortedContinents = continents.sorted()
                for continent in sortedContinents {
                    if let countries = countries[continent] {
                        let section = Section(contenient: continent, countries: countries)
                        self.sections.append(section)
                    }
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                print("Failed to fetch countries: \(error)")
            }
        }
    }
    
    private func addAllSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setup() {
        view.backgroundColor = .white
    }
    
    private func setupSkeletons() {
        let calc = CalculateValues()
        let row = calc.makeSkeleton()
        collectionView.reloadData()
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func handleLearnMoreTap(for country: CountryModel) {
        userDefaults.set(country.cca2.lowercased(), forKey: "code")
        let vc = CountryDetailsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}


extension CountriesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        return CGSize(width: widthPerItem, height: isSelected ? 240: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension CountriesListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        return true
    }
}

extension CountriesListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CustomSectionHeaderView.headerResuseId, for: indexPath) as! CustomSectionHeaderView
            let region = sections[indexPath.section].contenient
            headerView.titleLabel.text = region.uppercased()
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isLoaded {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCell.reuseId, for: indexPath) as! CountryCell
            
            let country = sections[indexPath.section].countries[indexPath.item]
            cell.configureCell(model: country)
            
            cell.learnMoreAction = { [weak self] in
                self?.handleLearnMoreTap(for: country)
            }
            
            return cell
        }
        
        let scelcell = collectionView.dequeueReusableCell(withReuseIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        
        return scelcell
    }
}

