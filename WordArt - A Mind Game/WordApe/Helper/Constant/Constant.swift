//
//  Constant.swift
//  WordArt
//
//

import Foundation
import UIKit

class ThemeColor {
    static let themeOrange = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1.0)
    static let themeGreen = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1.0)
    static let themeLightGrey = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1.0)
    static let themeGrey = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
}

class GameResult {
    static var shared: GameResult = GameResult()
    
    func setUserDefaults(isWon: Bool, currentRow: Int) {
        var numOfPlayedGame = Int()
        var numOfWonGame = Int()
        var dictScore = [[String: Any]]()
        if let playedGame = UserDefaults.standard.value(forKey: "game_played") as? Int {
            numOfPlayedGame = playedGame + 1
            UserDefaults.standard.set(numOfPlayedGame, forKey: "game_played")
        } else {
            UserDefaults.standard.set(1, forKey: "game_played")
        }
        
        if let wonGame = UserDefaults.standard.value(forKey: "game_won") as? Int {
            if isWon {
                numOfWonGame = wonGame + 1
            } else {
                numOfWonGame = wonGame
            }
            UserDefaults.standard.set(numOfWonGame, forKey: "game_won")
        } else {
            if isWon {
                UserDefaults.standard.set(1, forKey: "game_won")
            } else {
                UserDefaults.standard.set(0, forKey: "game_won")
            }
        }
        
        if let dictAverage = UserDefaults.standard.value(forKey: "dict_average") as? [[String: Any]] {
            dictScore = dictAverage
            if currentRow != 6 {
                if let updateIndex = dictScore[currentRow]["won"] as? Int {
                    if isWon {
                        dictScore[currentRow]["won"] = updateIndex + 1
                        UserDefaults.standard.set(dictScore, forKey: "dict_average")
                    } else {
                        UserDefaults.standard.set(dictScore, forKey: "dict_average")
                    }
                }
            }
        } else {
            for i in 1...6 {
                var dict = [String: Any]()
                if i == currentRow + 1 {
                    if isWon {
                        dict = ["row": i, "won": 1]
                    } else {
                        dict = ["row": i, "won": 0]
                    }
                    
                } else {
                      dict = ["row": i, "won": 0]
                }
                
                dictScore.append(dict)
            }
            UserDefaults.standard.set(dictScore, forKey: "dict_average")
        }
    }
    
    func getUserDefaults() -> (numOfGame: Int, percentOfwin: Int, average: String) {
        var numOfPlayedGame = Int()
        var numOfwonGame = Int()
        var perOfWonGame = Int()
        var average = Int()
        var formattedAverage = String()
        var dictScores = [[String: Any]]()
        if let playedGame = UserDefaults.standard.value(forKey: "game_played") as? Int {
            numOfPlayedGame = playedGame
        }
        
        if let wonGame = UserDefaults.standard.value(forKey: "game_won") as? Int {
            numOfwonGame = wonGame
            perOfWonGame = wonGame * 100 / numOfPlayedGame
        }
        
        if let dictAverage = UserDefaults.standard.value(forKey: "dict_average") as? [[String: Any]] {
            dictScores = dictAverage
            var sum = Int()
            for dictScore in dictScores {
                if let row = dictScore["row"] as? Int, let won = dictScore["won"] as? Int {
                        print(row, won)
                        sum += row * won
                 
                    print(sum)
                }
            }
            if numOfwonGame != 0 {
                average = sum / numOfwonGame
            } else {
                average = 0
            }
            
            if average == 1 {
                formattedAverage = "\(average)st"
            } else if average == 2 {
                formattedAverage = "\(average)nd"
            }else if average == 3 {
                formattedAverage = "\(average)rd"
            }else if average == 4 || average == 5 || average == 6 {
                formattedAverage = "\(average)th"
            } else {
                formattedAverage = "0"
            }
        }
        return(numOfPlayedGame, perOfWonGame, formattedAverage)
    }
}


class DataOfFile {
    static var shared:DataOfFile = DataOfFile()
    func getRandomWordsFromCSV(fileName:String, fileType: String) -> [String] {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return []
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            let csvRows = csv(data: contents)
            print(csvRows)
            return csvRows
            
        } catch {
            print("File Read Error for file \(filepath)")
            return[]
        }
        
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [String] {
        let rows =  data.components(separatedBy: NSCharacterSet.newlines) as [String]
        return rows
    }
}


