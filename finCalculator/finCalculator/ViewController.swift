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
    @IBOutlet weak var NetCF: UITextField!
    @IBOutlet weak var InitialFund: UITextField!
    
    //  @IBOutlet weak var interestRate: UISlider!
    
    var bal = 400.0
    var intRate = 3.00
    var initCap = 0.2
    var fee = 400.0
    var taxes = 2000.0
    var cashInPM = 1800.0
    var invTerm = 30.0
    var returnCap = 0.0
    var NetCashflow = 0.0
    var InitFund = 0.0
    
    @IBAction func calculateROC(_ sender: Any) {
        bal = Double((balance.text)!)! * 1000
        intRate = Double((interestRate.text)!)! * 0.01
        initCap = Double((initialCapital.text)!)!
        fee = Double((fees.text)!)!
        taxes = Double((tax.text)!)!
        cashInPM = Double((cashInflowPerMo.text)!)!
        invTerm = Double((investmentTerm.text)!)!
        
        NetCashflow = calcNetCF(bal: bal, intRate: intRate, initCap: initCap, fee: fee, taxes: taxes, cashInPM: cashInPM, invTerm: invTerm)
        
        returnCap = calcROC(bal: bal, intRate: intRate, initCap: initCap, fee: fee, taxes: taxes, cashInPM: cashInPM, invTerm: invTerm)
        
        InitFund = bal * initCap;
        
        NetCF.text = String(NetCashflow)
        returnOfCapital.text = String(returnCap)
        InitialFund.text = String (InitFund)
    }
    
    @IBAction func optimize(_ sender: Any) {
        
        let intRateList = [0.01, 0.03, 0.04, 0.05]
        let initCapList = [0.2, 0.4, 0.8, 0.9, 0.95]
        let invTermList = [10.0]
        
        for intRate in intRateList {
            print("-------")
            for initCap in initCapList {
                for invTerm in invTermList {
                    
                    bal = Double((balance.text)!)! * 1000
                    //                intRate = Double((interestRate.text)!)! * 0.01
                    //                initCap = Double((initialCapital.text)!)!
                    fee = Double((fees.text)!)!
                    taxes = Double((tax.text)!)!
                    cashInPM = Double((cashInflowPerMo.text)!)! + 350.0 * (intRate - 0.03) * 100.0
                    //                invTerm = Double((investmentTerm.text)!)!
                    
                    NetCashflow = calcNetCF(bal: bal, intRate: intRate, initCap: initCap, fee: fee, taxes: taxes, cashInPM: cashInPM, invTerm: invTerm)
                    
                    returnCap = calcROC(bal: bal, intRate: intRate, initCap: initCap, fee: fee, taxes: taxes, cashInPM: cashInPM, invTerm: invTerm)
                    
                    print("interest: \(intRate) downpay: \(initCap) term: \(invTerm) cashin: \(cashInPM) ROC: \(returnCap)")
                }
            }
        }
       
        
        
        
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
        NetCF.text = String(NetCashflow)
        returnOfCapital.text = String(returnCap)
        InitialFund.text = String(InitFund)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calcNetCF(bal: Double, intRate: Double, initCap: Double, fee: Double, taxes: Double, cashInPM: Double, invTerm: Double) -> Double {
        
        let cashInFlow = cashInPM * 12;
        let PMT = calcPMT(bal: bal, initCap: initCap, intRate: intRate, invTerm: invTerm)
        let cashOutFlow = 12 * fee + taxes + PMT
        return (cashInFlow - cashOutFlow)
    
    }
    
    
    func calcROC(bal: Double, intRate: Double, initCap: Double, fee: Double, taxes: Double, cashInPM: Double, invTerm: Double) -> Double {
    
        let cashInFlow = cashInPM * 12
        let cashOutFlow = 12 * fee + taxes + bal * intRate
        
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
