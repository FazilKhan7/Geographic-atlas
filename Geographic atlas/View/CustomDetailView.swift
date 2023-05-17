//
//  CustomDetailView.swift
//  StrongTeamTestAssignmentChecker
//
//  Created by Bakhtiyarov Fozilkhon on 15.05.2023.
//

import Foundation
import UIKit

class CustomDetailView: UIView {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6034177542, green: 0.6034177542, blue: 0.6034177542, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    lazy var subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.backgroundColor = .black
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: layer.frame.width - 50, height: 80)
    }
    
    private func addAllSubviews() {
        addSubview(circleView)
        addSubview(title)
        addSubview(subTitle)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 15),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            subTitle.leadingAnchor.constraint(equalTo: circleView.trailingAnchor, constant: 15)
        ])
    }
}
