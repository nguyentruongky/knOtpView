//
//  knOtpView.swift
//  knOtpView
//
//  Created by Ky Nguyen Coinhako on 4/23/18.
//  Copyright © 2018 kynguyen. All rights reserved.
//

import UIKit

class knOTPView: knView {
    private let color_69_125_245 = UIColor(red: 69/255, green: 125/255, blue: 245/255, alpha: 1)
    private let color_102 = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
    private let color_253_102_127 = UIColor(red: 253/255, green: 102/255, blue: 127/255, alpha: 1)
    lazy var hiddenTextField = self.addHiddenTextField()
    private var labels = [UILabel]()
    private var digitCount = 0
    private var validate: ((String) -> Void)?
    private var isInvalid = false {
        didSet {
            if isInvalid { setCodeError(); return }
            hiddenTextField.text = ""
            for i in 0 ..< digitCount {
                setCode(at: i, active: false)
                labels[i].textColor = color_69_125_245
                labels[i].text = ""
            }
            setCode(at: 0, active: true)
        }}
    
    convenience init(digitCount: Int, validate: @escaping ((String) -> Void)) {
        self.init(frame: CGRect.zero)
        self.digitCount = digitCount
        self.validate = validate
        setupView()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        hiddenTextField.becomeFirstResponder()
        return true
    }
    
    private func addHiddenTextField() -> UITextField {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .numberPad
        tf.isHidden = true
        tf.delegate = self
        
        addSubviews(views: tf)
        tf.fill(toView: self)
        
        return tf
    }
    
    override func setupView() {
        guard digitCount > 0 else { return }
        var constraints = "H:|-8-"
        for i in 0 ..< digitCount {
            let label = makeLabel()
            if i > 0 {
                label.width(toView: labels[0])
            }
            constraints += "[v\(i)]-8-"
        }
        constraints += "|"
        addConstraints(withFormat: constraints, arrayOf: labels)
        height(60)
        
        setCode(at: 0, active: true)
        hiddenTextField.becomeFirstResponder()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
    }
    
    private func makeLabel() -> UILabel {
        let label = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 45),
                                   color: color_69_125_245,
                                   alignment: .center)
        label.createRoundCorner(5)
        label.createBorder(0.5, color: color_102)
        addSubview(label)
        label.vertical(toView: self)
        labels.append(label)
        return label
    }
}


extension knOTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = string
        if isInvalid {
            isInvalid = false
        }
        else {
            newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        }
        let codeLength = newText.length
        guard codeLength <= digitCount else { return false }
        textField.text = newText
        
        func setTextToActiveBox() {
            for i in 0 ..< codeLength {
                let char = newText.substring(from: i, to: i)
                labels[i].text = char
                setCode(at: i, active: true)
            }
        }
        
        func setTextToInactiveBox() {
            for i in codeLength ..< digitCount {
                labels[i].text = ""
                setCode(at: i, active: false)
            }
            
            if codeLength <= digitCount - 1 {
                setCode(at: codeLength, active: true)
            }
        }
        
        setTextToActiveBox()
        setTextToInactiveBox()
        
        if codeLength == digitCount {
            validateCode(code: textField.text!)
        }
        return false
    }
    
    func setCode(at index: Int, active: Bool) {
        labels[index].createBorder(active ? 1 : 0.5,
                                  color: active ? color_69_125_245 : color_102)
    }
    
    func setCodeError() {
        for i in 0 ..< digitCount {
            labels[i].createBorder(0.5, color: color_253_102_127)
            labels[i].textColor = color_253_102_127
        }
    }
    
    func validateCode(code: String) {
        validate?(code)
    }
}












