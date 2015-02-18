//
//  GamePiece.swift
//  GameBoard
//


import UIKit


enum PieceType: Int {
    
    case Empty
    case Player1
    case Player2
    
    case Player1King
    case Player2King
    
}

class GamePiece: UIView {

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
    
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
