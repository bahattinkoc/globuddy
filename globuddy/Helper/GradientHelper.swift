//
//  GradientHelper.swift
//  globuddy
//
//  Created by BAHATTIN KOC on 27.11.2024.
//

import UIKit

final class GradientHelper {

    // MARK: - PROPERTIES

    static var selectedUserBackgroundColor: [UIColor] = [
        UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0),
        UIColor(red: 0.0, green: 0.8, blue: 0.4, alpha: 1.0),
        UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0),
        UIColor(red: 0.6, green: 1.0, blue: 0.6, alpha: 1.0)
    ]
    static var unselectedUserBackgroundColor: [UIColor] = [
        UIColor(red: 1.0, green: 0.0, blue: 0.66, alpha: 1.0),
        UIColor(red: 0.54, green: 0.23, blue: 0.73, alpha: 1.0),
        UIColor(red: 1.0, green: 0.86, blue: 0.50, alpha: 1.0)
    ]

    // MARK: - INTERNAL FUNCTIONS

    static func createGradientImage(size: CGSize = .init(width: 100, height: 100), colors: [UIColor]) -> UIImage? {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = .init(origin: .zero, size: size)
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 1)
        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
