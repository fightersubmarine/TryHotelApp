//
//  UIActivityIndicatorView+Extension.swift
//  TryHotelApp
//
//  Created by Александр on 26.05.2024.
//

import UIKit

extension UIActivityIndicatorView {
    static func customActivityIndicator() -> UIActivityIndicatorView {
        var activity = UIActivityIndicatorView()
        activity = UIActivityIndicatorView(style: .large)
        activity.hidesWhenStopped = true
        return activity
    }
}
