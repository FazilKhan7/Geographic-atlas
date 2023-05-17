//
//  SkeletonCell.swift
//  Geographic atlas
//
//  Created by Bakhtiyarov Fozilkhon on 17.05.2023.
//

import Foundation
import UIKit

class SkeletonCell: UICollectionViewCell {
    
    static let reuseID = "SkeletonCell"
    
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
    
    lazy var countryName = UILabel()
    lazy var capitalName = UILabel()
    
    lazy var countryNameLayer = CAGradientLayer()
    lazy var capitalNameLayer = CAGradientLayer()
    lazy var imageLayer = CAGradientLayer()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayers()
        setupAnimation()
        layout()
        
    }
    
    func setup() {
        countryName.adjustsFontSizeToFitWidth = true
        countryName.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        countryName.text = "------------------------"
        
        capitalName.adjustsFontSizeToFitWidth = true
        capitalName.font = UIFont.systemFont(ofSize: 15, weight: .light)
        capitalName.text = "----------"
    }
    
    func layout() {
        
        contentView.addSubview(countryImage)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(countryName)
        stackView.addArrangedSubview(capitalName)
        
        NSLayoutConstraint.activate([
            countryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countryImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: countryImage.trailingAnchor, constant: 10),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupLayers() {
        
        countryNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        countryNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        countryName.layer.addSublayer(countryNameLayer)
        
        capitalNameLayer.startPoint = CGPoint(x: 0, y: 0.5)
        capitalNameLayer.endPoint = CGPoint(x: 1, y: 0.5)
        capitalName.layer.addSublayer(capitalNameLayer)
        
        imageLayer.startPoint = CGPoint(x: 0, y: 0.5)
        imageLayer.endPoint = CGPoint(x: 1, y: 0.5)
        countryImage.layer.addSublayer(imageLayer)
        
    }
    
    
    private func setupAnimation() {
        let capitalGroup = makeAnimationGroup()
        capitalGroup.beginTime = 0.0
        capitalNameLayer.add(capitalGroup, forKey: "backgroundColor")
        
        let nameGroup = makeAnimationGroup(previousGroup: capitalGroup)
        countryNameLayer.add(nameGroup, forKey: "backgroundColor")
        
        let imageGroup = makeAnimationGroup(previousGroup: capitalGroup)
        imageLayer.add(imageGroup, forKey: "backgroundColor")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.countryNameLayer.frame = self.countryName.bounds
            self.countryNameLayer.cornerRadius = self.countryName.bounds.height/2
            
            self.capitalNameLayer.frame = self.capitalName.bounds
            self.capitalNameLayer.cornerRadius = self.capitalName.bounds.height/2
            
            self.imageLayer.frame = self.countryImage.bounds
            self.imageLayer.cornerRadius = 10
        }
    }
}

extension SkeletonCell: SkeletonLoadable {
    
}
