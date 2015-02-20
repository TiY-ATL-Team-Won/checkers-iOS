//
//  GamePiece.swift
//  GameBoard
//


import UIKit

struct boardLocation {
    
    var x: Int
    var y: Int
    
    
    
}



protocol GamePieceDelegate {
    
    func pieceSelected(piece: GamePiece)
    
}

enum PieceType: Int {
    
    case Empty
    case Player1
    case Player2
    
    case Player1King
    case Player2King
    
}

class GamePiece: UIView {

    var player: Player? {
        
        var index = 0
        
        let playerIndex = (type.rawValue - 1) % 2
        return DataModel.mainData().currentGame?.players[playerIndex]
        
    }
    
    ///(col,row) (x,y)
    var square: (Int,Int)!
    
    var delegate: GamePieceDelegate?

    var type: PieceType!
    
    init(type: PieceType) {
        
        super.init(frame: CGRectMake(0,0,20,20))
        self.type = type
        
        backgroundColor = type.hashValue % 2 == 0 ? UIColor.whiteColor() : UIColor.grayColor()
        
        layer.cornerRadius = 10

        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        // piece selected
        // change color for selection
        
        delegate?.pieceSelected(self)
        
        if let touch = touches.allObjects.last as? UITouch {
            
            let location = touch.locationInView(self)
            
            let col = 
            let row =
            
            let selectedPiece = DataModel.mainData().currentGame?.boardPieces[row][col]
        }
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
