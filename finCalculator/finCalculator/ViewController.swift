//
//  ViewController.swift
//  finCalculator
//
//  Created by Li Zhang on 2/11/18.
//  Copyright © 2018 Li Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var balance: UITextField!
    @IBOutlet weak var interestRate: UITextField!
    @IBOutlet weak var initialCapital: UITextField!
    @IBOutlet weak var fees: UITextField!
    @IBOutlet weak var tax: UITextField!
    @IBOutlet weak var cashInflowPerMo: UITextField!
    @IBOutlet weak var investmentTerm: UITextField!
    @IBOutlet weak var returnOfCapital: UITextField!
    
    var bal = 400000.0
    var intRate = 0.03
    var initCap = 0.2
    var fee = 400.0
    var taxes = 2000.0
    var cashInPM = 1800.0
    var invTerm = 30.0
    var returnCap = 0.0
    
    @IBAction func calculateROC(_ sender: Any) {
        bal = Double((balance.text)!)!
        intRate = Double((interestRate.text)!)!
        initCap = Double((initialCapital.text)!)!
        fee = Double((fees.text)!)!
        taxes = Double((tax.text)!)!
        cashInPM = Double((cashInflowPerMo.text)!)!
        invTerm = Double((investmentTerm.text)!)!
        
        returnCap = calcROC(bal: bal, intRate: intRate, initCap: initCap, fee: fee, taxes: taxes, cashInPM: cashInPM, invTerm: invTerm)
        
        returnOfCapital.text = String(returnCap)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
        
        balance.text = String(bal)
        interestRate.text = String(intRate)
        initialCapital.text = String(initCap)
        fees.text = String(fee)
        tax.text = String(taxes)
        cashInflowPerMo.text = String(cashInPM)
        investmentTerm.text = String(invTerm)
        returnOfCapital.text = String(returnCap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func calcROC(bal: Double, intRate: Double, initCap: Double, fee: Double, taxes: Double, cashInPM: Double, invTerm: Double) -> Double {
    
        let cashInFlow = cashInPM * 12
        let PMT = calcPMT(bal: bal, initCap: initCap, intRate: intRate, invTerm: invTerm)
        let cashOutFlow = 12 * fee + taxes + PMT
        
        return (cashInFlow - cashOutFlow)/(initCap * bal)
    }
    
    func calcPMT(bal: Double, initCap: Double, intRate: Double, invTerm: Double) -> Double {

        let PMT = bal * (1 - initCap) * intRate * pow((1 + intRate), invTerm) / (pow((1 + intRate), invTerm) - 1)
        
        return PMT
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
