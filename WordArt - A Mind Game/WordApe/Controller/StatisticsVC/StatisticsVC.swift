//
//  StatisticsVC.swift
//  WordArt
//
//
//  Created by Praharsh Gaudani on 28/09/22.
//

import UIKit

class StatisticsVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var lblNumOfPlayedGame: UILabel!
    @IBOutlet var lblWonPercentage: UILabel!
    @IBOutlet var lblAverage: UILabel!
    
    //MARK:- Variables
    var numOfPlayedGame: Int = 0
    var percentOfWonGame: Int = 0
    var average: String? = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialUI()
    }
    
    func setInitialUI() {
        let dictResult = GameResult.shared.getUserDefaults()
        self.numOfPlayedGame = dictResult.numOfGame
        self.percentOfWonGame = dictResult.percentOfwin
        self.average = dictResult.average
        
        self.lblNumOfPlayedGame.text = "\(self.numOfPlayedGame)"
        self.lblWonPercentage.text = "\(self.percentOfWonGame)%"
        self.lblAverage.text = self.average
    }
}

// MARK:- Action
extension StatisticsVC {
    
    @IBAction func onClickShare(_ sender: UIButton) {
        let text = "Check out (WordArt) on the Appstore.."
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onClickCancle(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
