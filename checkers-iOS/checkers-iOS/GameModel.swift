//
//  GameModel.swift
//  checkers-iOS
//
//  Created by Richard Tyran on 2/19/15.
//  Copyright (c) 2015 Bobby Towers. All rights reserved.
//

import UIKit

private let _mainData = DataModel()

class DataModel: NSObject {
    
    var allGames: [GameModel] = []
    var currentGame: GameModel?
    
    class func mainData() -> DataModel { return _mainData }
    
}

// board positions

class GameModel: NSObject {
    
    /// 0 = empty, 1 = player1, 2 = player2
    
    var id = 0
    
    let boardSquares = [
        
        [0,1,0,1,0,1,0,1],
        [1,0,1,0,1,0,1,0],
        [0,1,0,1,0,1,0,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [2,0,2,0,2,0,2,0],
        [0,2,0,2,0,2,0,2],
        [2,0,2,0,2,0,2,0]
        
    ]
    
    var boardPieces: [[GamePiece?]] = Array(count: 8, repeatedValue: Array(count: 8, repeatedValue: nil))
    
    var availableMoves: [(Int,Int)] = []
    
    // board squares [row][col]
    
    
    //players
    
    // you can use this direction when testing moves available
    
    var players: [Player] = [Player(direction: 1),Player(direction: -1)]
    
    
    
    // winner
    var winner: Player?
    var isDraw = false
    
    // moves made
    // kings per player
    
}

// var oppositeRow = player.direction == 1 ? 7 : 0

class Player: NSObject {
    
    var direction: Int!
    
    init(direction: Int) {
        
        super.init()
        self.direction = direction
        
        
        
    }
    
}
      