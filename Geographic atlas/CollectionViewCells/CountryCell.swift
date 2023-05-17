//
//  CountryCell.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 13.05.2023.
//

import Foundation
import UIKit

class CountryCell: UICollectionViewCell {
    
    static let reuseId = "CountryCell"
    
    private lazy var mainContainer = UIView()
    private lazy var topContainer = UIView()
    private lazy var bottomContainer = UIView()
    
    let calc = CalculateValues()
    let cacheImage = CachingImage()
    var learnMoreAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var countryImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: contentView.frame.height).isActive = true
        image.heightAnchor.constraint(equalToConstant: contentView.frame.height - 30).isActive = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    lazy var countryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private lazy var capitalName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var moreDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return button
    }()
    
    private lazy var populationText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private lazy var areaText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return label
    }()
    
    private lazy var currenciesText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var population: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Population:"
        label.textColor = #colorLiteral(red: 0.6034177542, green: 0.6034177542, blue: 0.6034177542, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var area: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Area:"
        label.textColor = #colorLiteral(red: 0.6034177542, green: 0.6034177542, blue: 0.6034177542, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var currencies: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Currencies:"
        label.textColor = #colorLiteral(red: 0.6034177542, green: 0.6034177542, blue: 0.6034177542, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var learnMore: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Learn more", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.5694641471, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return button
    }()
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.3) {
            let upsideDown = CGAffineTransform(rotationAngle: .pi * -0.999 )
            self.moreDetailsButton.transform = self.isSelected ? upsideDown : .identity
        }
    }
    
    private func configureView() {
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.clipsToBounds = true
        topContainer.backgroundColor = UIColor.systemGray6
        bottomContainer.backgroundColor = UIColor.systemGray6
        mainContainer.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer()
        bottomContainer.addGestureRecognizer(tapGesture)
        
        addAllSubviews()
        makeConstraints()
        updateAppearance()
    }
    
    private func makeConstraints() {
        
        NSLayoutConstraint.activate([
            countryImage.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12),
            countryImage.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            countryImage.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: countryImage.trailingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor),
            
            countryName.trailingAnchor.constraint(equalTo: moreDetailsButton.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            moreDetailsButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -12),
            moreDetailsButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            population.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 6),
            population.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            area.topAnchor.constraint(equalTo: population.bottomAnchor, constant: 8),
            area.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            currencies.topAnchor.constraint(equalTo: area.bottomAnchor, constant: 8),
            currencies.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            populationText.leadingAnchor.constraint(equalTo: population.trailingAnchor, constant: 4),
            populationText.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 6),
            
            areaText.leadingAnchor.constraint(equalTo: area.trailingAnchor, constant: 4),
            areaText.topAnchor.constraint(equalTo: population.bottomAnchor, constant: 8),
            
            currenciesText.leadingAnchor.constraint(equalTo: currencies.trailingAnchor, constant: 4),
            currenciesText.topAnchor.constraint(equalTo: area.bottomAnchor, constant: 8),
        ])
        
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            topContainer.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            topContainer.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            bottomContainer.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            bottomContainer.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        NSLayoutConstraint.activate([
            learnMore.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor, constant: -16),
            learnMore.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor)
        ])
    }
    
    private func addAllSubviews() {
        
        stackView.addArrangedSubview(countryName)
        stackView.addArrangedSubview(capitalName)
        
        topContainer.addSubview(countryImage)
        topContainer.addSubview(stackView)
        topContainer.addSubview(moreDetailsButton)
        
        bottomContainer.addSubview(population)
        bottomContainer.addSubview(populationText)
        
        bottomContainer.addSubview(area)
        bottomContainer.addSubview(areaText)
        
        bottomContainer.addSubview(currencies)
        bottomContainer.addSubview(currenciesText)
        
        bottomContainer.addSubview(learnMore)
        
        mainContainer.addSubview(topContainer)
        mainContainer.addSubview(bottomContainer)
        
        contentView.addSubview(mainContainer)
    }
    
    func configureCell(model: CountryModel) {
        countryName.text = model.name.common
        capitalName.text = model.capital?[0] ?? ""
        populationText.text = calc.reducePopulationSize(value: model.population)
        areaText.text = calc.reduceAreaSize(value: model.area)
        
        if let currenciesText = model.currencies?.compactMap({ (key, value) -> String? in
            return "\(value.name ?? "") (\(value.symbol ?? "")) (\(key))"
        }).joined(separator: "\n") {
            self.currenciesText.text = currenciesText
        }
        
        if let flagURL = URL(string: model.flags.png) {
            cacheImage.loadImage(from: flagURL) { image in
                guard let image = image else { return }
                DispatchQueue.main.async { [self] in
                    let desiredSize = CGSize(width: self.contentView.frame.height, height: self.contentView.frame.height - 30)
                    let resizedImage = self.calc.resizeImage(image, to: desiredSize)
                    self.countryImage.image = resizedImage
                }
            }
        }
        
        learnMore.addTarget(self, action: #selector(learnMoreButtonTapped), for: .touchUpInside)
    }
    
    @objc private func learnMoreButtonTapped() {
        learnMoreAction?()
    }
}


