//
//  InitalVC.swift
//  WordArt
//
//  Created by Praharsh Gaudani on 28/09/22.
//

import UIKit

class InitalVC: UIViewController {

    @IBOutlet var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 

    @IBAction func onClickEasyMode(_ sender: UIButton) {
        UserDefaults.standard.setValue(5, forKey: "mode")
    }
    
    @IBAction func onClickHardMode(_ sender: UIButton) {
        UserDefaults.standard.setValue(7, forKey: "mode")
    }
    
    @IBAction func btnNoLimit(_ sender: UIButton) {
        UserDefaults.standard.setValue(0, forKey: "time")
    }
    
    @IBAction func btn5Min(_ sender: UIButton) {
        UserDefaults.standard.setValue(5, forKey: "time")
    }
    @IBAction func btn1Min(_ sender: UIButton) {
        UserDefaults.standard.setValue(1, forKey: "time")
    }
    @IBAction func btn2Min(_ sender: UIButton) {
        UserDefaults.standard.setValue(2, forKey: "time")
    }
    
    @IBAction func btnForest(_ sender: UIButton) {
        UserDefaults.standard.setValue("forest", forKey: "theme")
    }
    
    @IBAction func btnDessert(_ sender: UIButton) {
        UserDefaults.standard.setValue("desert", forKey: "theme")
    }
    
    @IBAction func btnSpace(_ sender: UIButton) {
        UserDefaults.standard.setValue("space", forKey: "theme")
    }
    
    @IBAction func btnStart(_ sender: UIButton) {
        UserDefaults.standard.setValue(txtName.text, forKey: "name")
        
        if let mode = UserDefaults.standard.value(forKey: "mode") as? Int {
            if mode == 5 {
                let navigateToVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
                self.navigationController?.pushViewController(navigateToVC!, animated: true)
            } else {
                let navigateToVC = self.storyboard?.instantiateViewController(withIdentifier: "SevenBoxVC") as? SevenBoxVC
                self.navigationController?.pushViewController(navigateToVC!, animated: true)
            }
        } else {
            let navigateToVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            self.navigationController?.pushViewController(navigateToVC!, animated: true)
        }
    }
}
