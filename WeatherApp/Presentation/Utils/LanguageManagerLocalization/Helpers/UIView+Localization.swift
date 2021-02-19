//
//  UIView+Localization.swift
//  WeatherApp
//
//  Created by Amir on 1/6/21.
//

import UIKit

extension UIView {
  ///
  /// Change the direction of the view depeneding in the language, there is no return value for this variable.
  ///
  /// The expectid values:
  ///
  /// -`fixed`: if the view must not change the direction depending on the language.
  ///
  /// -`leftToRight`: if the view must change the direction depending on the language
  /// and the view is left to right view.
  ///
  /// -`rightToLeft`: if the view must change the direction depending on the language
  /// and the view is right to left view.
  ///
  var direction: ViewDirections {
    set {
      switch newValue {
      case .fixed:
        break
      case .leftToRight where LanguageManager.shared.isRightToLeft:
        transform = CGAffineTransform(scaleX: -1, y: 1)
      case .rightToLeft where !LanguageManager.shared.isRightToLeft:
        transform = CGAffineTransform(scaleX: -1, y: 1)
      default:
        break
      }
    }
    get {
      fatalError("There is no value return from this variable, this variable used to change the view direction depending on the langauge")
    }
  }
}
