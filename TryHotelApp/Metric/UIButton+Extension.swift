//
//  UIButton+Extension.swift
//  TryHotelApp
//
//  Created by Александр on 23.05.2024.
//

import UIKit

private extension CGFloat {
    static let borderWidth = 3.0
    static let cornerRadius = 10.0
}

extension UIButton {
    static func customSortButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = CGFloat.cornerRadius
        button.layer.borderWidth = CGFloat.borderWidth
        button.layer.borderColor = UIColor.borderColor.cgColor
        button.clipsToBounds = true
        return button
    }
}
