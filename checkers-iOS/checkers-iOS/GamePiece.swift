//
//  GamePiece.swift
//  GameBoard
//


import UIKit

//struct boardLocation {
//    
//    var x: Int
//    var y: Int
//    
//    
//}

protocol GamePieceDelegate {
    
    func pieceSelected(piece: GamePiece)
    
}

enum PieceType: Int {
    
    case Empty
    case Player1
    case Player2
    
    case Player1King
    case Player2King
    
    var description : String {
        get {
            switch(self) {
            case .Empty:
                return "Empty"
            case .Player1:
                return "PlayerOne"
            case .Player2:
                return "PlayerTwo"
            case .Player1King:
                return "PlayerOneKing"
            case .Player2King:
                return "PlayerTwoKing"
            }
        }
    }

    func other() -> PieceType {
        switch(self){
            
        case .Empty: return .Empty
        case .Player1: return .Player2
        case .Player2: return .Player1
        case .Player1King: return .Player2
        case .Player2King: return .Player1
        }
        
    }

}

class GamePiece: UIView {

    var type: PieceType!
    
    var row: Int?
    var col: Int?
    var player: Player? {
        
        var index = 0
        
        switch type! {
            
        case .Player1, .Player1King :
            index = 0
            
        case .Player2, .Player2King:
            index = 1
        case .Empty :
            index = 0
            
        }
        
        // do that so that player 1 (enum 1 and 3) = 0 and player 2 (enum 2 and 4 == 1)
        let playerIndex = (type.rawValue + 1) % 2
        return DataModel.mainData().currentGame?.players[playerIndex]
        
    }
    
    
    /// (col, row)
    var square: (Int, Int)! {
        
        didSet {
            
            /// change center
            
        }
        
    }
    
    var delegate: GamePieceDelegate?
    
    
    // IF WE OVERRIDE THE INIT AND OUR CLASS IS RELATED TO THE STORYBOARD (BUTTON, UIVIEW) WE HAVE TO IMPLEMENT THE REQUIRED INIT
    
    // EVERYTIME WE IMPLEMENT SOMETHING THAT INHERITS WITH UIVIEW WE NEED TO INITWITHFRAME
    init(type: PieceType) {
        
        super.init(frame: CGRectMake(0, 0, 20, 20))
        self.type = type
        
        // hashValue gives you 0, 1, 2, 3, 4
        // if our enum is of type: Int, String we can call rawValue (in the case of string would return a string), otherwise we call hashValue (we can still call hashValue)
        
        if self.type == .Empty {
            return
        }
            
        else {
            backgroundColor = type.hashValue % 2 == 0 ? UIColor.cyanColor() : UIColor.yellowColor()
        }
        
        
        layer.cornerRadius = 10
    }
    
    
    // this inits the UIView on the storyboard
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        
        
        // piece selected
        
        delegate?.pieceSelected(self)
        // change color for selection
    }
    
    func changeColor(color: UIColor) {
        backgroundColor = color
    }
    
    func changeColorToOriginal() {
        if self.type == .Empty {
            return
        }
            
        else {
            backgroundColor = type.hashValue % 2 == 0 ? UIColor.whiteColor() : UIColor.grayColor()
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
