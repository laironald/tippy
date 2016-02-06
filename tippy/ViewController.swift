//
//  ViewController.swift
//  tippy
//
//  Created by Ron Lai on 2/4/16.
//  Copyright (c) 2016 RonCo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var tipSelect: UISegmentedControl!


    func formatNumber(num: Double) -> String {
        var formatter = NSNumberFormatter();
        formatter.numberStyle = .CurrencyStyle;
        formatter.maximumFractionDigits = 2;
        
        return formatter.stringFromNumber(num)!;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tipLabel.text = formatNumber(0);
        totalLabel.text = formatNumber(0);
    }
    override func viewDidAppear(animated: Bool) {
        // auto select billText
        billText.becomeFirstResponder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditingChange(sender: AnyObject) {
        var billAmount = billText.text._bridgeToObjectiveC().doubleValue
        var tip = billAmount * [0.18, 0.20, 0.22][tipSelect.selectedSegmentIndex];
        var total = billAmount + tip;
        
        tipLabel.text = formatNumber(tip);
        totalLabel.text = formatNumber(total);
    }
}

