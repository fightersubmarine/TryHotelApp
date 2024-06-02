//
//  HotelCollectionViewCell.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//

import UIKit

private extension CGFloat {
    static let cornerRadius = 10.0
    static let borderWidth = 3.0
}

final class HotelCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    private lazy var nameCellLabel: UILabel = {
        let label = labelForCell.customLabelForCell(text: "")
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private lazy var imageForCell: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        return image
    }()
    
    private lazy var addressCellLabel: UILabel = {
        let label = labelForCell.customLabelForCell(text: "")
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var starsCellLabel: UILabel = {
        let label = labelForCell.customLabelForCell(text: "")
        return label
    }()
    
    private lazy var distanceCellLabel: UILabel = {
        let label = labelForCell.customLabelForCell(text: "")
        return label
    }()
    
    private lazy var suitesCellLabel: UILabel = {
        let label = labelForCell.customLabelForCell(text: "")
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSelf()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - UI  Configuration
    
    private func setupSelf() {
        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = CGFloat.borderWidth
        self.layer.cornerRadius = CGFloat.cornerRadius
        self.layer.borderColor = UIColor.borderColor.cgColor
        setupHierarchy()
    }
    
    func configure(with hotel: MainScreenModel) {
        nameCellLabel.text = hotel.name
        addressCellLabel.text = hotel.address
        starsCellLabel.text = "Stars: \(hotel.stars)"
        distanceCellLabel.text = "Distance: \(hotel.distance) km"
        suitesCellLabel.text = "Suites: \(hotel.formattedSuitesAvailability)"
    }
    
    private func setupHierarchy() {
        addSubview(nameCellLabel)
        addSubview(imageForCell)
        addSubview(addressCellLabel)
        addSubview(starsCellLabel)
        addSubview(distanceCellLabel)
        addSubview(suitesCellLabel)
    }
    
    private func setupLayout() {
        nameCellLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constraint.constant2)
            $0.leading.trailing.equalToSuperview()
        }
        
        imageForCell.snp.makeConstraints {
            $0.top.equalTo(nameCellLabel.snp.bottom).offset(Constraint.constant2)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(Constraint.constant96)
        }
        
        addressCellLabel.snp.makeConstraints {
            $0.top.equalTo(imageForCell.snp.bottom).offset(Constraint.constant8)
            $0.leading.trailing.equalToSuperview().offset(Constraint.constant16)
        }
        
        starsCellLabel.snp.makeConstraints {
            $0.top.equalTo(addressCellLabel.snp.bottom).offset(Constraint.constant8)
            $0.leading.equalToSuperview().offset(Constraint.constant16)
        }
        
        distanceCellLabel.snp.makeConstraints {
            $0.top.equalTo(starsCellLabel.snp.bottom).offset(Constraint.constant8)
            $0.leading.equalToSuperview().offset(Constraint.constant16)
        }
        
        suitesCellLabel.snp.makeConstraints {
            $0.top.equalTo(distanceCellLabel.snp.bottom).offset(Constraint.constant8)
            $0.leading.equalToSuperview().offset(Constraint.constant16)
            $0.bottom.equalToSuperview().inset(Constraint.constant16)
        }
    }
}
