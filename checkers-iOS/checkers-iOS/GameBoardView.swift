//
//  GameBoardView.swift
//  GameBoard
//

import UIKit

/// 0 = empty, 1 = player1, 2 = player2


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

// board squares [row][col]


@ IBDesignable class GameBoardView: UIView {
    
    let gridSize = 8
    
   override func layoutSubviews() {
    
        for (rowIndex,rowArray) in enumerate(boardSquares)  {
            
            for (columnIndex,squarePieceType) in enumerate(rowArray) {
              
                if squarePieceType == 0 { continue }
                
                println(squarePieceType)
                if let type = PieceType(rawValue: squarePieceType) {
                    
                    var piece = GamePiece(type: type)
                    
                    boardPieces[rowIndex][columnIndex] = piece
                    
                    let cF = CGFloat(columnIndex)
                    let rF = CGFloat(rowIndex)
                    
                    let squareSize = frame.width / CGFloat(gridSize)
                    
                    let x = cF * squareSize + squareSize / 2
                    let y = rF * squareSize + squareSize / 2
                    
                    piece.center = CGPointMake(x, y)
                    
                    
                    addSubview(piece)
                    
                }
                
                
//                var piece = GamePiece(type: PieceType.Player1)
                
                
            }
        }
    }
    
    
    
    override func drawRect(rect: CGRect) {
    
        var context = UIGraphicsGetCurrentContext()
        
        
            // loop through cols
        
        for c in 0..<gridSize {
            
            // loop through rows
    
            for r in 0..<gridSize {
                
                
                // you have to have an INT, not a float, so we have to convert the INT into a float.
        
                let cF = CGFloat(c)
                let rF = CGFloat(r)
                
                let squareSize = rect.width / CGFloat(gridSize)
                
                let x = cF * squareSize
                let y = rF * squareSize
            
                let color = (c + r) % 2 == 0 ? UIColor(red:0.55,green:0.00,blue:0.00,alpha:1): UIColor.blackColor()
                color.set()
                
                CGContextFillRect(context, CGRectMake(x, y, squareSize, squareSize))
                
                
            
            
            
            }
            
            
        }
        
    
    }
    

}
