//
//  Model.swift
//  WordArt
//
//

import Foundation
import UIKit

class Tile {
    var id: String!
    var row: Int!
    var index: Int!
    var label: UILabel?
    var view: customTileView?
    var isContain: Bool!
    var isPlaced: Bool!
    var charIndex: Int!
    var key: UIButton?
    
    init(id: String, row: Int, index: Int, label: UILabel, view: customTileView?, isContain: Bool, isPlaced: Bool, charIndex: Int, key: UIButton) {
        self.id = id ?? ""
        self.row = row ?? 0
        self.index = index
        self.label = label
        self.view = view
        self.isContain = isContain ?? false
        self.isPlaced = isPlaced
        self.charIndex = charIndex
        self.key = key
    }
    
}

struct Key {
    var id: String?
    var isContain: Bool?
    var isPlaced: Bool?
    var button: UIButton?
    
    init(id: String, isContain: Bool, isPlaced: Bool, button: UIButton) {
        self.id = id
        self.isContain = isContain
        self.isPlaced = isPlaced
        self.button = button
    }
}
