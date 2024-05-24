//
//  ViewController.swift
//  WordArt
//
//  Created by Praharsh Gaudani on 28/09/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet var viewRow0: [customTileView]!
    @IBOutlet var viewRow1: [customTileView]!
    @IBOutlet var viewRow2: [customTileView]!
    @IBOutlet var viewRow3: [customTileView]!
    @IBOutlet var viewRow4: [customTileView]!
    @IBOutlet var viewRow5: [customTileView]!
    
    @IBOutlet var lblRow0: [UILabel]!
    @IBOutlet var lblRow1: [UILabel]!
    @IBOutlet var lblRow2: [UILabel]!
    @IBOutlet var lblRow3: [UILabel]!
    @IBOutlet var lblRow4: [UILabel]!
    @IBOutlet var lblRow5: [UILabel]!
    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lblVerifyWord: UILabel!
    
    @IBOutlet var resultView: UIView!
    @IBOutlet var lblIcon: UILabel!
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var bgImage: UIImageView!
    
    //MARK:- Variables
    var currentRow: Int = 0
    var currentTile: Tile?
    var currentTileIndex = 0
    var arrRowTiles = [Tile]()
    var arrRandomWords = [String]()
    var arrValidWords = [String]()
    var isDelete = false
    var randomWord = String()
    var arrAllTiles = [[Tile]]()
    var arrKeyObject = [Key]()
    var arrViewRows = [[customTileView]]()
    var matchCount = 0
    
    var isWordMatch = false
    
    var player: AVAudioPlayer?
    var countTimer:Timer!
    var counter = 0
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialUI()
    }
    
    func setInitialUI() {
        // Initially seleceted tile
        self.viewRow0.first?.borderWidth = 2.0
        self.viewRow0.first?.borderColor = .black

        self.arrViewRows.append(self.viewRow0)
        self.arrViewRows.append(self.viewRow1)
        self.arrViewRows.append(self.viewRow2)
        self.arrViewRows.append(self.viewRow3)
        self.arrViewRows.append(self.viewRow4)
        self.arrViewRows.append(self.viewRow5)
        
        // Fetch random word
        self.fetchRandomWord()
    
        
        // Statistics
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "statistic"), style: .plain, target: self, action: #selector(onClickStatistics))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        self.btnSubmit.isHidden = false
        
        if let bg = UserDefaults.standard.value(forKey: "theme") as? String {
            self.bgImage.image = UIImage(named: bg)
        }
        if let timeCount = UserDefaults.standard.value(forKey: "time") as? Int {
            counter = timeCount * 60
        }
        self.countTimer = Timer.scheduledTimer(timeInterval: 1 ,
                                                     target: self,
                                                     selector: #selector(self.changeTitle),
                                                     userInfo: nil,
                                                     repeats: true)
    }
}

// User Defined function
extension ViewController {
    // Choose any random word from array
    func fetchRandomWord() {
        // Fetch word dictionary
        self.arrValidWords = DataOfFile.shared.getRandomWordsFromCSV(fileName: "five-letter-words", fileType: "txt")
        
        // Fetch random word list
        self.arrRandomWords = DataOfFile.shared.getRandomWordsFromCSV(fileName: "five-letter-words", fileType: "csv")
        
        // Choose random word from list
        if self.arrRandomWords.count != 0 {
            self.randomWord = self.arrRandomWords.randomElement()?.lowercased() ?? ""
            print(self.randomWord)
        }
    }
    
    // Create single tile Object
    func createTileObject(label: UILabel, view: customTileView, key: UIButton) {
        // Check single character, If it contain in random word then return index
        let obj = self.getCharacterPostion(char: label.text?.lowercased() ?? "")
        
        // Create Tile object
        let tileObj = Tile(id: "\(self.currentRow)\(self.currentTileIndex)", row: self.currentRow, index: self.currentTileIndex, label: label, view: view, isContain: obj.isContain, isPlaced: obj.isPlaced, charIndex: obj.index, key: key)
        
            // Create key object for set keyboard background color
        self.createKeyObject(id: String(describing: label.text!.capitalized), isContain: obj.isContain, isPlaced: obj.isPlaced, key:  key)
        
        self.arrRowTiles.append(tileObj)
    }
    
    // Create single pressed keyboard key object
    func createKeyObject(id: String, isContain: Bool, isPlaced: Bool, key: UIButton) {
        let keyObj = Key(id: String(describing: id), isContain: isContain, isPlaced: isPlaced, button: key)
        self.arrKeyObject.append(keyObj)
    }
    
    // Check if input character is contain in random word, if yes then get index of character
    func getCharacterPostion(char: String) -> (index:Int, isContain: Bool, isPlaced: Bool) {
        let dataArrayString = Array(char)
        var indexOfChar = Int()
        var isContain = Bool()
        var isPlaced = Bool()
        for chars in dataArrayString{
            // Get index of input character from string
            if let i = self.randomWord.firstIndex(of: chars) {
                indexOfChar = i.utf16Offset(in:self.randomWord)
                isContain = true
                // Check if input character is at same index, that it should be
                if indexOfChar == self.currentTileIndex {
                    isPlaced = true
                } else {
                    isPlaced = false
                }
            } else {
                // If index is 100, It means random word doesn't contain input character
                indexOfChar = 100
                isContain = false
                isPlaced = false
            }
        }
        
        return(indexOfChar, isContain, isPlaced)
    }
    
    // Verify input word is valid or not
    func validateWord() -> Bool {
        
        var characters = [String]()
        var word = String()
        let row = self.getCurrentRow()
        // Merge perticular row's tile character into string for validating word
        for tile in row.labels {
            characters.append((tile.text)!)
        }
        word = characters.joined(separator: "")
       // self.currentRowWord = word.lowercased()
        print(word.lowercased())
        if word == "" {
            return false
        }
        
        if word.lowercased() == self.randomWord.lowercased() {
            // If user input word is same as chosen random word
            self.isWordMatch = true
        }
        
        if self.arrValidWords.count != 0 {
            if self.arrValidWords.contains(word.lowercased()) {
                return true
            } else {
                self.lblVerifyWord.text = "Not a valid word."
                self.btnSubmit.isHidden = true
                return false
            }
        }
        return false
    }
    
    // Change perticular row's all tile background colour after validating word
    func changeTileBackground() {
    
        for tile in self.arrRowTiles {
            if tile.isContain == true && tile.isPlaced == true || self.isWordMatch {
                // Random word contain the character at same index
                self.matchCount += 1
                tile.view?.backgroundColor = ThemeColor.themeGreen
                tile.view?.borderWidth = 0.0
                tile.view?.borderColor = .clear
                tile.label?.textColor = .white
                tile.key?.backgroundColor = ThemeColor.themeGreen
            } else if tile.isContain == true && tile.isPlaced == false {
                // Random word contain the character, but index isn't same
                tile.view?.backgroundColor = ThemeColor.themeOrange
                tile.view?.borderWidth = 0.0
                tile.view?.borderColor = .clear
                tile.label?.textColor = .white
                tile.key?.backgroundColor = ThemeColor.themeOrange
            } else if tile.charIndex == 100 {
                // Random word doesn't contain the character
                tile.view?.backgroundColor = ThemeColor.themeGrey
                tile.view?.borderWidth = 0.0
                tile.view?.borderColor = .clear
                tile.label?.textColor = .white
                tile.key?.backgroundColor = ThemeColor.themeGrey
            }
        }
        
        // If isWordMatch == true, It means user guess correct word & If currentRow == 5, It means User is not able guess coreect word and out of max try
        if self.currentRow == 5 || self.isWordMatch {
            self.resultView.isHidden = false
            self.setResultView()
            // Increase total played game count
            if let numOfPlayedGame = UserDefaults.standard.value(forKey: "played_game") as? Int {
                // If already played game
               let count = numOfPlayedGame + 1
                UserDefaults.standard.set(count, forKey: "played_game")
            } else {
                // Play for the first time
                UserDefaults.standard.set(1, forKey: "played_game")
            }
        }
        
        self.arrAllTiles.append(self.arrRowTiles)
        self.arrRowTiles.removeAll()
        self.arrKeyObject.removeAll()
    }
    
    func setCurrentTile(text: String, viewRow: [customTileView], lblRow: [UILabel], key: UIButton) {
        print("--- Add tile at \(self.currentTileIndex) ---")
        if self.currentRow <= 5 {
            if self.currentTileIndex < 5 {
                // Set character at perticular index
                if self.currentTileIndex == 4 && lblRow[self.currentTileIndex].text != "" {
                  //If last tile of row, can't change last character
                } else {
                    lblRow[self.currentTileIndex].text = text
                    lblRow[self.currentTileIndex].textColor = .black
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        lblRow[self.currentTileIndex].font = .systemFont(ofSize: 40.0, weight: .medium)
                    } else {
                        lblRow[self.currentTileIndex].font = .systemFont(ofSize: 28.0, weight: .medium)
                    }
                    
                    self.createTileObject(label: lblRow[self.currentTileIndex], view: viewRow[self.currentTileIndex], key: key)
                    if lblRow[self.currentTileIndex].text != "" && self.currentTileIndex != 4{
                        self.currentTileIndex += 1
                        print("--- Current Index \(self.currentTileIndex) ---")
                    }
                   
                }
                
            }
        }
    }
    
    func deleteTile(viewRow: [customTileView], lblRow: [UILabel]) {
        print("--- Delete tile from \(self.currentTileIndex) ---")
        if lblRow[self.currentTileIndex].text == "" && self.currentTileIndex != 0 {
            self.currentTileIndex -= 1
        }
        let text = lblRow[self.currentTileIndex].text
        lblRow[self.currentTileIndex].text = ""
        if self.currentTileIndex >= 0 {
            
            if let indexOfTile = self.arrRowTiles.firstIndex(where: { $0.index == viewRow[self.currentTileIndex].tag }) {
                self.arrRowTiles.remove(at: indexOfTile)
            }
            
            if let indexOfKey = self.arrKeyObject.lastIndex(where: { $0.id == text?.capitalized }) {
                self.arrKeyObject.remove(at: indexOfKey)
            }
            
            lblRow[self.currentTileIndex].text = ""
            
            if !self.isWordMatch {
                self.setBorderToTile()
            }
          
        }
    }
    
    func setBorderToTile() {
        
        let row = getCurrentRow()
        
        // If user press delete character
        if isDelete {
            for view in row.views {
                if self.currentTileIndex <= 4 {
                    if view.tag == self.currentTileIndex{
                        view.borderColor = .black
                        view.borderWidth = 2.0
                        
                        if self.currentTileIndex != 4 {
                            row.views[self.currentTileIndex + 1].borderWidth = 1.0
                            row.views[self.currentTileIndex + 1].borderColor = .lightGray
                        }
                    }
                }
            }
        } else {
            // If user add character
            for view in row.views {
                if view.tag == self.currentTileIndex {
                    view.borderColor = .black
                    view.borderWidth = 2.0
                } else if self.currentTileIndex == 0 {
                    row.views.first?.borderColor = .black
                    row.views.first?.borderWidth = 2.0
                }
            }
        }
        
    }
    
    // Get Current row and returns all the tile's elements
    func getCurrentRow() -> (views:[customTileView], labels: [UILabel], index: Int) {
        var viewRow = [customTileView]()
        var lblRow = [UILabel]()
        var index = 0
        if self.currentRow == 0 {
            viewRow = self.viewRow0
            lblRow = self.lblRow0
            index = 0
        } else if self.currentRow == 1 {
            viewRow = self.viewRow1
            lblRow = self.lblRow1
            index = 1
        }else if self.currentRow == 2 {
            viewRow = self.viewRow2
            lblRow = self.lblRow2
            index = 2
        }else if self.currentRow == 3 {
            viewRow = self.viewRow3
            lblRow = self.lblRow3
            index = 3
        }else if self.currentRow == 4 {
            viewRow = self.viewRow4
            lblRow = self.lblRow4
            index = 4
        }else if self.currentRow == 5 {
            viewRow = self.viewRow5
            lblRow = self.lblRow5
            index = 5
        }
        
        return (viewRow, lblRow, index)
    }
    
    func setResultView() {
        
        self.btnSubmit.isHidden = true
        self.resultView.isHidden = false
        
        if self.isWordMatch {
            self.lblIcon.text = "🎉"
            if let name = UserDefaults.standard.value(forKey: "name") as? String{
                self.lblMessage.text = "Great job! \(name). The word was:"
            } else {
                self.lblMessage.text = "Great job!. The word was:"
            }
         
            self.lblDescription.text = self.randomWord.uppercased()
            self.playSound(sound: "won")
            GameResult.shared.setUserDefaults(isWon: true, currentRow: self.currentRow)
        } else {
            self.lblIcon.text = "😞"
            if let name = UserDefaults.standard.value(forKey: "name") as? String{
                self.lblMessage.text = "Better luck next time \(name). The word was:"
            } else {
                self.lblMessage.text = "Better luck next time. The word was:"
            }
          
            self.lblDescription.text = self.randomWord.uppercased()
            self.playSound(sound: "loss")
            GameResult.shared.setUserDefaults(isWon: false, currentRow: self.currentRow)
        }
   
    }
    
    func playSound(sound: String, ext: String = "wav") {
        let url = Bundle.main.url(forResource: sound, withExtension: ext)!

        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            player.prepareToPlay()
            player.play()

        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @objc func changeTitle()
    {
         if counter != 0
         {
             self.lblTimer.text = "Remaining Time: \(counter) Seconds"
             counter -= 1
         }
         else
         {
              countTimer.invalidate()
             if let timeCount = UserDefaults.standard.value(forKey: "time") as? Int, timeCount != 0 {
                 let alert = UIAlertController(title: "Oops!!!", message: "Game Over", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                     self.navigationController?.popViewController(animated: true)
                 }))
                 self.present(alert, animated: true, completion: nil)
             }
            
         }

    }
}

// MARK:- Action
extension ViewController {
    
    @IBAction func onClickKeyboard(_ sender: UIButton) {
        // Hide word not found label
        self.playSound(sound: "tap", ext: "mp3")
        self.lblVerifyWord.text = ""
        self.btnSubmit.isHidden = false
        let row = getCurrentRow()
        
        // User press back button for delete character
        // tag 101 is stands for back button
        if sender.tag == 101 {
            self.isDelete = true
            self.btnSubmit.isEnabled = false
            self.btnSubmit.backgroundColor = .lightGray
            self.deleteTile(viewRow: row.views, lblRow: row.labels)
            
        } else {
            self.isDelete = false
            if self.currentTileIndex >= 4 {
                self.btnSubmit.isEnabled = true
                self.btnSubmit.backgroundColor = .blue
                self.setCurrentTile(text: sender.titleLabel?.text ?? "", viewRow: row.views, lblRow: row.labels, key: sender)
                if !self.isWordMatch {
                    self.setBorderToTile()
                }
            } else {
                self.btnSubmit.isEnabled = false
                self.btnSubmit.backgroundColor = .lightGray
                self.setCurrentTile(text: sender.titleLabel?.text ?? "", viewRow: row.views, lblRow: row.labels, key: sender)
                if !self.isWordMatch {
                    self.setBorderToTile()
                }
            }
        }
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        // If word is found, then row +=1
        if self.validateWord() {
            self.changeTileBackground()
            self.currentRow += 1
            self.matchCount = 0
            self.currentTileIndex = 0
            if self.currentRow <= 5 {
                self.arrViewRows[self.currentRow].first?.borderWidth = 2.0
                self.arrViewRows[self.currentRow].first?.borderColor = .black
            }
        }
    }
    
    @IBAction func onClickPlayAgain(_ sender: UIButton) {
        self.resultView.isHidden = true
        self.btnSubmit.isHidden = false
        let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.setViewControllers([initialViewController], animated: false)
    }
    
    @IBAction func onClickViewStats(_ sender: UIButton) {
        self.btnSubmit.isHidden = false
        self.onClickStatistics()
    }
    
    @objc func onClickStatistics() {
        self.performSegue(withIdentifier: "goToStatistics", sender: nil)
    }
}
