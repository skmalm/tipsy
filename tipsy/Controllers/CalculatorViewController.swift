//
//  ViewController.swift
//  tipsy
//
//  Created by Sebastian Malm on 2/17/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    //TODO: Fix calculator autolayout to put items into green and white views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.value = Constants.defaultStepperValue
        textField.delegate = self
        addTapRecognizer()
    }

    func calculator() -> TipCalculator {
        var billTotalString = textField.text ?? "$0.00"
        if billTotalString == "" { billTotalString = "0.00" }
        // remove dollar sign from string before casting to double
        billTotalString.removeFirst()
        let billTotal = Double(billTotalString) ?? 0.0
        var tip = 0.0
        for tipButton in tipButtons {
            if tipButton.isSelected {
                if tipButton.currentTitle! == "10%" {
                    tip = 0.1
                } else if tipButton.currentTitle! == "20%" {
                    tip = 0.2
                }
            }
        }
        let split = Int(splitLabel.text!)!
        return TipCalculator(billTotal: billTotal, tipPercentage: tip, splitQuantity: split)
    }
    
    @IBAction func calculateButtonWasTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "Show Result", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        assert(segue.identifier == "Show Result", "Segue identifier error")
        if let resultViewController = segue.destination as? ResultViewController {
            resultViewController.calculator = calculator()
        }
    }
    
    private func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func viewWasTapped() {
        view.endEditing(true)
    }
    
    @IBAction private func tipButtonWasTapped(_ sender: UIButton) {
        for tipButton in tipButtons {
            tipButton.isSelected = false
        }
        sender.isSelected = true
    }
    
    @IBAction private func stepperValueWasChanged(_ sender: UIStepper) {
        splitLabel.text = Int(sender.value).description
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var tipButtons: [UIButton]!
    @IBOutlet weak private var splitLabel: UILabel!
    @IBOutlet weak private var stepper: UIStepper!
    @IBOutlet weak var calculateButton: UIButton! {
        didSet {
            calculateButton.layer.cornerRadius = Constants.buttonCornerRadius
        }
    }
    
}

extension CalculatorViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = text.currencyFormatting()
    }
}


extension CalculatorViewController {
    struct Constants {
        static let buttonCornerRadius: CGFloat = 15.0
        static let defaultStepperValue: Double = 2.0
    }
}

extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        var output = self
        // remove possible $ before attempting to cast to Double
        if let firstCharacter = output.first {
            if firstCharacter == "$" { output.removeFirst() }
        }
        if let value = Double(output) {
            let nsNumberValue = NSNumber(value: value)
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            if let str = formatter.string(from: nsNumberValue) {
                return str
            }
        }
        // return empty string if failed to cast value to Double
        return ""
    }
}
