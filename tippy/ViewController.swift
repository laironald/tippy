//
//  ViewController.swift
//  tippy
//
//  Created by Ron Lai on 2/4/16.
//  Copyright (c) 2016 RonCo. All rights reserved.
//

import UIKit

/////////////////////////
// global stuff        //
// - this feels hacky! //
/////////////////////////
var tipArray = [10, 15, 20];
var billValues: [String:Double] = [
    "bill": 0,
    "tip": 0,
    "total": 0,
    "people": 2,
    "pay": 0
];

func formatNumber(num: Double) -> String {
    var formatter = NSNumberFormatter();
    formatter.numberStyle = .CurrencyStyle;
    formatter.maximumFractionDigits = 2;
    
    return formatter.stringFromNumber(num)!;
}
//////////////////////////

class DetailsViewController: UIViewController {
    @IBOutlet weak var billLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var peopleLabel: UILabel!
    @IBOutlet weak var payLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        billLabel.text = formatNumber(billValues["bill"]!);
        totalLabel.text = formatNumber(billValues["total"]!);
        tipLabel.text = formatNumber(billValues["tip"]!);
        peopleLabel.text = String(format: "%.0f", billValues["people"]!);
        payLabel.text = formatNumber(billValues["pay"]!);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class SettingsViewController: UIViewController {
    @IBOutlet weak var tip1Text: UITextField!
    @IBOutlet weak var tip2Text: UITextField!
    @IBOutlet weak var tip3Text: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        tip1Text.text = String(tipArray[0]);
        tip2Text.text = String(tipArray[1]);
        tip3Text.text = String(tipArray[2]);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func tipChange(sender: AnyObject) {
        if tip1Text.text != "" {
            tipArray[0] = tip1Text.text.toInt()!;
        }
        if tip2Text.text != "" {
            tipArray[1] = tip2Text.text.toInt()!;
        }
        if tip3Text.text != "" {
            tipArray[2] = tip3Text.text.toInt()!;
        }
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var tipSelect: UISegmentedControl!
    @IBOutlet weak var payerSelect: UISegmentedControl!
    @IBOutlet weak var payLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payLabel.text = formatNumber(0);
    }
    override func viewDidAppear(animated: Bool) {
        // auto select billText only if empty
        if billText.text == "" {
            billText.becomeFirstResponder();
        }
        onEditingChange(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditingChange(sender: AnyObject) {
        billValues["bill"] = billText.text._bridgeToObjectiveC().doubleValue;
        billValues["tip"] = billValues["bill"]! * Double(tipArray[tipSelect.selectedSegmentIndex]) / 100;
        billValues["total"] = billValues["bill"]! + billValues["tip"]!;
        billValues["people"] = Double(payerSelect.selectedSegmentIndex + 1);
        billValues["pay"] = Double(ceil(100 * billValues["total"]! / billValues["people"]!) / 100);

        payLabel.text = formatNumber(billValues["pay"]!);
    }
    // clear taps on UISegmentedControl too
    @IBAction func onSelectChange(sender: UISegmentedControl) {
        onTap(true);
        onEditingChange(true);
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
    }
}

