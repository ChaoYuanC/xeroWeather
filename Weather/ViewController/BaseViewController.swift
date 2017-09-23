//
//  BaseViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet var loadingView: UIView?
    @IBOutlet var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideloadingView(_ hide: Bool) {
        if hide {
            self.indicator?.stopAnimating()
            self.loadingView?.isHidden = true
        } else {
            self.indicator?.startAnimating()
            self.loadingView?.isHidden = false
        }
    }

}
