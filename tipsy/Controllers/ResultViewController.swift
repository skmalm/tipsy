//
//  ResultViewController.swift
//  tipsy
//
//  Created by Sebastian Malm on 2/18/20.
//  Copyright © 2020 SebastianMalm. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var calculator: TipCalculator?
    
    @IBAction private func recalculateButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBOutlet weak var totalPerPersonLabel: UILabel! {
        didSet {
            totalPerPersonLabel.text = calculator?.totalPerPerson.string(style: .currency)
        }
    }
    @IBOutlet weak var summaryLabel: UILabel! {
        didSet {
            if let split = calculator?.splitQuantity,
                let decimalPercentage = calculator?.tipPercentage {
                summaryLabel.text = "Split among \(split) people, with\n\(decimalPercentage.string(style: .percent)) tip."
            }
        }
    }
    @IBOutlet weak var recalculateButton: UIButton! {
        didSet {
            recalculateButton.layer.cornerRadius = CalculatorViewController.Constants.buttonCornerRadius
        }
    }
}

extension Double {
    // Double method for converting to currency string
    func string(style: NumberFormatter.Style) -> String {
        let nsNumberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = style
        if let str = formatter.string(from: nsNumberValue) {
            return str
        }
        return "error"
    }
}
