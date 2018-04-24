//
//  ViewController.swift
//  knOtpView
//
//  Created by Ky Nguyen Coinhako on 4/23/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var otpView = knOTPView(digitCount: 6, validate: self.validateOtp)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view.addSubviews(views: otpView)
        otpView.horizontal(toView: view, space: 8)
        otpView.top(toView: view, space: 120)
    }
    
    func validateOtp(_ code: String) {
        let controller = UIAlertController(title: "Validate code", message: "Your code is " + code, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(controller, animated: true)
    }
}

