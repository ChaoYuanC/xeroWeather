//
//  UIViewController+Extension.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func showAlerWith(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
}
