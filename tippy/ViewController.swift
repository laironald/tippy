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

/* I've decided to keep these all in the same file. If they were to get huge, I would separate */

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

//////////////////////////

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

//////////////////////////

class ViewController: UIViewController {

    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var tipSelect: UISegmentedControl!
    @IBOutlet weak var payerSelect: UISegmentedControl!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var payerLabel: UILabel!
    @IBOutlet weak var payLabel1: UILabel!
    @IBOutlet weak var payLabel2: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payLabel.text = formatNumber(0);
    }
    override func viewDidAppear(animated: Bool) {
        // auto select billText only if empty
        if billText.text == "" {
            billText.becomeFirstResponder();
            onBillText(true);
        }
        onEditingChange(true);
        let transitionOptions = UIViewAnimationOptions.TransitionCurlUp
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
        let people = String(format: "%.0f", billValues["people"]!);
        let tip = String(format: "%.0f", billValues["tip"]!);
        if billValues["people"] == 1 {
            //couldnt figure out how to do string interpolation w/ dictionaries
            payLabel1.text = "at \(tip)%:";
            payLabel2.text = "you pay";
        } else {
            payLabel1.text = "\(people) people at \(tip)%:";
            payLabel2.text = "each person pays";
        }
    }
    // clear taps on UISegmentedControl too
    @IBAction func onSelectChange(sender: UISegmentedControl) {
        onTap(true);
        onEditingChange(true);
    }
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true);
        UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.CurveEaseInOut,animations: {
            self.payerLabel.alpha = 1;
            self.payerSelect.alpha = 1;
            self.tipLabel.alpha = 1;
            self.tipSelect.alpha = 1;
            self.changeLabel.alpha = 0;
            self.payLabel.frame.origin.y = 415;
            self.payLabel1.frame.origin.y = 365;
            self.payLabel2.frame.origin.y = 385;
            }, completion: { (finished: Bool) -> () in
                
        });
    }
    @IBAction func onBillText(sender: AnyObject) {
        UIView.transitionWithView(self.view, duration: 0.5, options: UIViewAnimationOptions.CurveEaseInOut,animations: {
            self.payerLabel.alpha = 0;
            self.payerSelect.alpha = 0;
            self.tipLabel.alpha = 0;
            self.tipSelect.alpha = 0;
            self.changeLabel.alpha = 1;
            self.payLabel.frame.origin.y = 215; //415
            self.payLabel1.frame.origin.y = 165; //365
            self.payLabel2.frame.origin.y = 185; //385
            }, completion: { (finished: Bool) -> () in
                
        });
    }
}

