//
//  UILable+Extension.swift
//  TryHotelApp
//
//  Created by Александр on 16.05.2024.
//


import UIKit

typealias labelForCell = UILabel
typealias labelForHotelScreen = UILabel

private extension CGFloat {
    static let fontSizeLabelCell = 20
    static let fontSizeLabelHotelScreen = 30
}

extension labelForCell {
    static func customLabelForCell(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(CGFloat.fontSizeLabelCell))
        label.backgroundColor = .clear
        label.sizeToFit()
        label.text = text
        label.textAlignment = .left
        label.textColor = .black
        return label
    }
}

extension labelForHotelScreen {
    static func customLabelForHotelScreen(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(CGFloat.fontSizeLabelHotelScreen))
        label.backgroundColor = .clear
        label.text = text
        label.textAlignment = .left
        label.textColor = .black
        label.sizeToFit()
        label.numberOfLines = .zero
        return label
    }
}
