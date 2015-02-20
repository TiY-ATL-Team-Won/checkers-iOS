//
//  GameBoardView.swift
//  GameBoard
//

import UIKit



/// 0 = empty, 1 = player1, 2 = player2
enum PlayerType {
    
    case Empty
    case Player1
    case Player2
    
    case Player1King
    case Player2King
    
}

// board squares [row][col]


@IBDesignable class GameBoardView: UIView, GamePieceDelegate {
    
    let gridSize = 8
    
    var piece = PieceType.Empty
    
    override func layoutSubviews() {
        
        if let boardSquares = DataModel.mainData().currentGame?.boardSquares {
            
            for (rowIndex,rowArray) in enumerate(boardSquares)  {
                
                for (columnIndex,squarePieceType) in enumerate(rowArray) {
                    
                    if squarePieceType == 0 { continue }
                    
//                    println(squarePieceType)
                    if let type = PieceType(rawValue: squarePieceType) {
                        
                        var piece = GamePiece(type: type)
                        
                        piece.square = (columnIndex, rowIndex)
                        piece.delegate = self
                        
                        DataModel.mainData().currentGame?.boardPieces[rowIndex][columnIndex] = piece
                        
                        let cF = CGFloat(columnIndex)
                        let rF = CGFloat(rowIndex)
                        
                        let squareSize = frame.width / CGFloat(gridSize)
                        
                        let x = cF * squareSize + squareSize / 2
                        let y = rF * squareSize + squareSize / 2
                        
                        piece.center = CGPointMake(x, y)
                        
                        addSubview(piece)
                        
                    }
                    
                    
                    // var piece = GamePiece(type: PieceType.Player1)
                    
                    
                }
            }
        }
    }
    
    func pieceSelected(piece: GamePiece) {
        
        let (c,r) = piece.square
        let spotTopRight = DataModel.mainData().currentGame?.boardPieces[c + 1][r - 1]
        let spotTopLeft = DataModel.mainData().currentGame?.boardPieces[c - 1][r - 1]
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if let touch = touches.allObjects.last as? UITouch {
            
            let location = touch.locationInView(self)
            
            let squareSize = frame.width / CGFloat(gridSize)
            
            let col = Int(floor(location.x / squareSize))
            let row = Int(floor(location.y / squareSize))
            
            let selectedSquare = DataModel.mainData().currentGame?.boardPieces[row][col]
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
