//
//  GameBoardView.swift
//  GameBoard
//

import UIKit

@IBDesignable class GameBoardView: UIView , GamePieceDelegate, validMoveProtocol {
    
    
    let gridSize = 8
    
    var previouslySelected: Bool?
    
    var previouslySelectedPiece: GamePiece?
    
    var piecesCreated = false
    
    var currentPlayer: PieceType?
    
    // nib is the frame of the VC (the entity that is holding the view and everything)
    override func layoutSubviews() {
        
        currentPlayer = PieceType.Player1
        User.currentUser().delegate3 = self
        
        previouslySelected = false
        
        if !piecesCreated {
            
            
            if let boardSquares = DataModel.mainData().currentGame?.boardSquares {
                for (rowIndex, rowArray) in enumerate(boardSquares) {
                    
                    
                    for (columnIndex, squarePieceType) in enumerate(rowArray) {
                        
                        
                        
                        if squarePieceType == 0 {
                            var piece = GamePiece(type: PieceType.Empty)
                            
                            piece.delegate = self
                            
                            piece.square = (columnIndex, rowIndex)
                            
                            DataModel.mainData().currentGame?.boardPieces[rowIndex][columnIndex] = piece
                            
                            let cF = CGFloat(columnIndex)
                            let rF = CGFloat(rowIndex)
                            
                            let squareSize = frame.width / CGFloat(gridSize)
                            
                            let x = cF * squareSize + squareSize/2
                            let y = rF * squareSize + squareSize/2
                            
                            
                            piece.center = CGPointMake(x, y)
                            
                            addSubview(piece)
                            
                            continue
                        }
                        
                        if let type = PieceType(rawValue: squarePieceType) {
                            
                            var piece = GamePiece(type: type)
                            
                            piece.delegate = self
                            
                            piece.square = (columnIndex, rowIndex)
                            
                            DataModel.mainData().currentGame?.boardPieces[rowIndex][columnIndex] = piece
                            
                            
                            let cF = CGFloat(columnIndex)
                            let rF = CGFloat(rowIndex)
                            
                            let squareSize = frame.width / CGFloat(gridSize)
                            
                            let x = cF * squareSize + squareSize/2
                            let y = rF * squareSize + squareSize/2
                            
                            
                            piece.center = CGPointMake(x, y)
                            //piece.frame = CGRectMake(0, 0, 20, 20)
                            
                            
                            addSubview(piece)
                            
                        }
                        
                        
                        
                        //   var piece = GamePiece(type: PieceType.Empty)
                        
                    }
                }
                
                
            }
            
            piecesCreated = true
            
        }
        
        
    }
    
    
    func pieceSelected(piece: GamePiece) {
        
        
        
        println(currentPlayer?.description)
        
        
        //        let (c, r) = piece.square
        
        
        var player = piece.type
        
        
        if  previouslySelectedPiece == nil {
            
            
            if (piece.type != PieceType.Empty) && (piece.type == currentPlayer) {
                previouslySelectedPiece = piece
                piece.changeColor(UIColor.redColor())
            }
            
        }
            
        else {
            previouslySelectedPiece?.changeColorToOriginal()
            
            
            var validOptions = getValidMoveOptions(previouslySelectedPiece!)
            
            
            var validJumpOptions = getValidJumpOptions(previouslySelectedPiece!)
            
            
            
            let (pieceCol,pieceRow) = piece.square
            
            let (previousCol,previousRow) = previouslySelectedPiece!.square
            
            for move in validOptions {
                
                
                
                let (moveCol,moveRow) = move.square
                
                
                
                
                if moveCol == pieceCol && moveRow == pieceRow {
                    
                    
                    
                    // var validMove = User.currentUser().sendMove(User.currentUser().token!, id: 1, start: (previouslySelectedPiece!.row!, previouslySelectedPiece!.col!), end: (piece.row!, piece.col!))
                    
                    //  if validMove == true {
                    let center = piece.center
                    
                    piece.center = previouslySelectedPiece!.center
                    previouslySelectedPiece?.center = center
                    
                    let square = piece.square
                    
                    piece.square = previouslySelectedPiece?.square
                    previouslySelectedPiece?.square = square
                    
                    DataModel.mainData().currentGame?.boardPieces[previousRow][previousCol] = piece
                    DataModel.mainData().currentGame?.boardPieces[pieceRow][pieceCol] = previouslySelectedPiece
                    
                    
                    self.detectWinsOrLosses()
                    currentPlayer = currentPlayer!.other()
                    //    }
                    
                    
                }
                
                
            }
            
            for (target, through) in validJumpOptions {
                
                
                let (targetCol, targetRow) = target.square
                
                let (throughCol, throughRow) = through.square
                
                
                if targetCol == pieceCol && pieceRow == targetRow {
                    
                    through.type = .Empty
                    through.changeColor(UIColor.clearColor())
                    
                    // change that
                    //                    through.removeFromSuperview()
                    
                    // take the center of the piece
                    let center = piece.center
                    // make the empty tile be at the previouslyselectedplayer
                    piece.center = previouslySelectedPiece!.center
                    //                    emptyPiece.center = through.center
                    //make the previouslyselectedTile be at the newlocation center
                    previouslySelectedPiece?.center = center
                    
                    //                    println(emptyPiece == piece)
                    
                    // update the squares
                    let square = piece.square
                    
                    piece.square = previouslySelectedPiece?.square
                    piece.type = .Empty
                    
                    //                    emptyPiece.square = through.square
                    previouslySelectedPiece?.square = square
                    //                    through.square = emptyPiece.square
                    
                    
                    
                    println("INITIALPIECE IN JUMP: position \(piece.square), type: \(piece.type.description)")
                    
                    println("previousrow, previousCOl: \(previousRow) \(previousCol)")
                    
                    DataModel.mainData().currentGame?.boardPieces[previousRow][previousCol] = piece
                    // DataModel.mainData().currentGame?.boardPieces[throughRow][throughCol] = emptyPiece
                    DataModel.mainData().currentGame?.boardPieces[pieceRow][pieceCol] = previouslySelectedPiece
                    
                    self.detectWinsOrLosses()
                    
                    currentPlayer = currentPlayer!.other()
                    
                    
                    
                    
                }
                
            }
            
            previouslySelectedPiece = nil
            
            
        }
        
        
        
    }
    
    
    
    func getValidJumpOptions(gamePiece: GamePiece) -> [(target: GamePiece, through: GamePiece)] {
        var options : [(target: GamePiece?, through: GamePiece?)] = []
        
        let (c, r) = gamePiece.square
        
        if (gamePiece.type == PieceType.Player1 || gamePiece.type == PieceType.Player1King) {
            
            
            
            // Diagonals up-lef and up right
            
            
            
            
            
            options.append(target: self.getValidPiece(r + 2, col: c + 2), through: self.getValidPiece(r + 1, col: c + 1))
            
            options.append(target: self.getValidPiece(r + 2, col: c - 2), through: self.getValidPiece(r + 1, col: c - 1))
            
            
            
        }
        
        var validJumpOptions : [(target: GamePiece, through: GamePiece)] = []
        if (gamePiece.type == PieceType.Player2 || gamePiece.type == PieceType.Player2King) {
            
            
            
            // Diagonals up-lef and up right
            
            
            
            
            options.append(target: self.getValidPiece(r - 2, col: c + 2), through: self.getValidPiece(r - 1, col: c + 1))
            
            options.append(target: self.getValidPiece(r - 2, col: c - 2), through: self.getValidPiece(r - 1, col: c - 1))
            
            
        }
        
        for (possibleTarget, through) in options {
            // if possible target is not nil
            if var validTarget = possibleTarget {
                
                // if the destination is nil and the through is the other player then can jump
                if validTarget.type == .Empty && through!.type == gamePiece.type.other() {
                    
                    validJumpOptions.append(target: possibleTarget!, through: through!)
                    
                }
            }
        }
        
        
        
        
        return validJumpOptions
        
    }
    
    
    
    
    /*
    func getValidJumpOptions(#player: Player, isKing: Bool) -> [(jump: Tile, previousSteps: [Tile])] {
    
    // our options for jump (not necesarry valid)
    // through is the tile we jump
    var options : [(target: Tile?, through: Tile?)] = []
    
    // two allowed diagonals for jumping for player 1 and king
    if (player == Player.One || isKing == true) {
    options.append(target: manager.getTile(row: self.row + 2, col: self.col + 2), through: manager.getTile(row: self.row + 1, col: self.col + 1))
    options.append(target: manager.getTile(row: self.row + 2, col: self.col - 2), through: manager.getTile(row: self.row + 1, col: self.col - 1))
    }
    if (player == Player.Two ||  player == Player.AI || isKing == true) {
    options.append(target: manager.getTile(row: self.row - 2, col: self.col + 2), through: manager.getTile(row: self.row - 1, col: self.col + 1))
    options.append(target: manager.getTile(row: self.row - 2, col: self.col - 2), through: manager.getTile(row: self.row - 1, col: self.col - 1))
    }
    
    
    // our valid options for the options above
    var validJumpOptions : [(jump: Tile, previousSteps: [Tile])] = []
    
    for (possibleTarget, through) in options {
    // if possible target is not nil
    if var validTarget = possibleTarget {
    
    // if the destination is nil and the through is the other player then can jump
    if validTarget.checker == nil && through!.checker?.player == player.other() {
    
    // PREVIOUS STEPS IS GOING TO BE USE IN FOR MULTIJUMP... LOOP BELOW
    var previousSteps : [Tile] = []
    
    // extend: Append the elements of `newElements`(the arguments) to `self`. (add all the validTargets and the emptyarray previoussteps)
    
    // an array of TUPLES (validTarget, [] (no previousSteps)
    validJumpOptions.extend([(validTarget, previousSteps)])
    // safety
    if through != nil {
    
    // add the valid targets to previous steps (THE SAME ONE)
    previousSteps.append(validTarget)
    }
    
    
    // redo the function recusively: if multiple jump will return other (multiJump, otherSteps) until no jumps
    // add the new previous steps to our previousSteps array and extend our valid Jump options
    // if confused: the previous steps and valid Jump Options never get reset because we are still in the loop and we just add the new return value to these arrays
    for (multiJump, otherSteps) in validTarget.getValidJumpOptions(player: player, isKing: isKing){
    previousSteps.extend(otherSteps)
    validJumpOptions.extend([(multiJump, previousSteps)])
    }
    }
    }
    }
    
    return validJumpOptions
    }
    
    
    
    */
    
    
    func detectWinsOrLosses() {
        if let boardSquares = DataModel.mainData().currentGame?.boardSquares {
            
            var noPlayer1Pieces = false
            var noPlayer2Pieces = false
            for (rowIndex, rowArray) in enumerate(boardSquares) {
                
                
                for (columnIndex, squarePieceType) in enumerate(rowArray) {
                    
                    if squarePieceType == 1 {
                        noPlayer1Pieces = true
                    }
                    if squarePieceType == 2 {
                        noPlayer2Pieces = true
                    }
                    
                }
            }
            
            if noPlayer1Pieces == false {
                var alert:UIAlertView = UIAlertView(title: "Message", message: "Player1 Wins", delegate: nil, cancelButtonTitle: "Ok")
                
                alert.show()
            }
            
            if noPlayer2Pieces == false {
                var alert:UIAlertView = UIAlertView(title: "Message", message: "Player2 Wins", delegate: nil, cancelButtonTitle: "Ok")
                
                alert.show()
            }
        }
        
    }
    
    
    func getValidMoveOptions(gamePiece: GamePiece) -> [GamePiece] {
        
        
        var options : [GamePiece?] = []
        
        let (c, r) = gamePiece.square
        
        if (gamePiece.type == PieceType.Player1 || gamePiece.type == PieceType.Player1King || gamePiece.type == PieceType.Player2King) {
            
            
            
            // Diagonals up-lef and up right
            
            
            
            
            
            
            options.append(self.getValidPiece(r + 1, col: c + 1))
            
            
            options.append(self.getValidPiece(r + 1, col: c - 1))
            
            
            
            
            
            
        }
        if (gamePiece.type == PieceType.Player2 || gamePiece.type == PieceType.Player1King || gamePiece.type == PieceType.Player2King) {
            
            // Diagonals below left and below right
            
            
            options.append(self.getValidPiece(r - 1, col: c + 1))
            
            
            options.append(self.getValidPiece(r - 1, col: c - 1))
            
            
            
            
        }
        
        
        
        
        var validOptions : [GamePiece] = []
        
        // safety
        for possibleValid in options {
            
            if var validTile = possibleValid {
                // if there is no checker then we can move
                
                
                if validTile.type == PieceType.Empty {
                    
                    
                    
                    
                    validOptions.append(validTile)
                    
                }
            }
        }
        
        return validOptions
    }
    
    
    func getValidPiece(row: Int, col: Int) -> GamePiece? {
        
        if row > 7 || row < 0 || col > 7 || col < 0 { return nil }
        
        var piece = DataModel.mainData().currentGame?.boardPieces[row][col] as GamePiece!
        
        return piece
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
    
    func validMove(isValid: Bool) -> Bool {
        
        return true
    }
    
    
    // gridSize has to be an int for the loop, but it has to be a float for the drawing
    override func drawRect(rect: CGRect) {
        //
        
        var context = UIGraphicsGetCurrentContext()
        
        for c in 0..<gridSize {
            
            for r in 0..<gridSize {
                
                let cF = CGFloat(c)
                let rF = CGFloat(r)
                
                let squareSize = rect.width / CGFloat(gridSize)
                
                let x = cF * squareSize
                let y = rF * squareSize
                
                let blueColor = UIColor.blueColor()
                
                let color = (c + r) % 2 == 0 ? UIColor.magentaColor() : UIColor.darkGrayColor()
                
                
                
                color.set()
                CGContextFillRect(context, CGRectMake(x, y, squareSize, squareSize))
                
                
            }
            
            
            
        }
        
        
    }
    
    
    
}


/*

func handleGesture(gestureRecognizer: UIGestureRecognizer) {
let point = gestureRecognizer.locationInView(self)

let loc = BoardLocation(x: abs(Int(floor(Double(point.x) / (Double(globalSquareSize!))))), y: abs(Int(floor(Double(point.y) / (Double(globalSquareSize!))))))


if delegate != nil {
delegate!.placeTouched(self, loc)
}


// send the locationInBord to our instance of manager
// Board!.processTouch(touched)


}

/*
override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
if let touch = touches.allObjects.first as? UITouch {

let point = touch.locationInView(self)

let loc = BoardLocation(x: abs(Int(floor(Double(point.x) / (Double(globalSquareSize!))))), y: abs(Int(floor(Double(point.y) / (Double(globalSquareSize!))))))

println("LOCATION.X: \(loc.x), LOCATION.Y: \(loc.y)")

// send the locationInBord to our instance of manager
// Board!.processTouch(touched)


if delegate != nil {
delegate!.placeTouched(self, loc)
}
}
}

override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {

if let touch = touches.allObjects.last as? UITouch {

}
}

*/


//var frameWidth: CGFloat?
// var globalSquareSize: CGFloat?
/// 0 = empty, 1 = player1, 2 = player2

// IN OUR BROJECT NOT BOARDSQUARES IN GLOBAL

// toCall boardSquares[row][col]


/*
protocol BoardViewDelegate {
func placeTouched(board: GameBoardView, _ location: BoardLocation)
}

}

struct BoardLocation {
var x: Int
var y: Int
}

*/*/

///// 0 = empty, 1 = player1, 2 = player2
//enum PlayerType {
//    
//    case Empty
//    case Player1
//    case Player2
//    
//    case Player1King
//    case Player2King
//    
//}
//
//// board squares [row][col]
//

//@IBDesignable class GameBoardView: UIView, GamePieceDelegate {
//    
//    let gridSize = 8
//    
//    var piece = PieceType.Empty
//    
//    override func layoutSubviews() {
//        
//        if let boardSquares = DataModel.mainData().currentGame?.boardSquares {
//            
//            for (rowIndex,rowArray) in enumerate(boardSquares)  {
//                
//                for (columnIndex,squarePieceType) in enumerate(rowArray) {
//                    
//                    if squarePieceType == 0 { continue }
//                    
////                    println(squarePieceType)
//                    if let type = PieceType(rawValue: squarePieceType) {
//                        
//                        var piece = GamePiece(type: type)
//                        
//                        piece.square = (columnIndex, rowIndex)
//                        piece.delegate = self
//                        
//                        DataModel.mainData().currentGame?.boardPieces[rowIndex][columnIndex] = piece
//                        
//                        let cF = CGFloat(columnIndex)
//                        let rF = CGFloat(rowIndex)
//                        
//                        let squareSize = frame.width / CGFloat(gridSize)
//                        
//                        let x = cF * squareSize + squareSize / 2
//                        let y = rF * squareSize + squareSize / 2
//                        
//                        piece.center = CGPointMake(x, y)
//                        
//                        addSubview(piece)
//                        
//                    }
//                    
//                    
//                    // var piece = GamePiece(type: PieceType.Player1)
//                    
//                    
//                }
//            }
//        }
//    }
//    
//    func pieceSelected(piece: GamePiece) {
//        
//        let (c,r) = piece.square
//        let spotTopRight = DataModel.mainData().currentGame?.boardPieces[c + 1][r - 1]
//        let spotTopLeft = DataModel.mainData().currentGame?.boardPieces[c - 1][r - 1]
//        
//    }
//    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        
//        if let touch = touches.allObjects.last as? UITouch {
//            
//            let location = touch.locationInView(self)
//            
//            let squareSize = frame.width / CGFloat(gridSize)
//            
//            let col = Int(floor(location.x / squareSize))
//            let row = Int(floor(location.y / squareSize))
//            
//            let selectedSquare = DataModel.mainData().currentGame?.boardPieces[row][col]
//        }
//    }
//
//    override func drawRect(rect: CGRect) {
//    
//        var context = UIGraphicsGetCurrentContext()
//        
//        
//            // loop through cols
//        
//        for c in 0..<gridSize {
//            
//            // loop through rows
//    
//            for r in 0..<gridSize {
//                
//                
//                // you have to have an INT, not a float, so we have to convert the INT into a float.
//        
//                let cF = CGFloat(c)
//                let rF = CGFloat(r)
//                
//                let squareSize = rect.width / CGFloat(gridSize)
//                
//                let x = cF * squareSize
//                let y = rF * squareSize
//            
//                let color = (c + r) % 2 == 0 ? UIColor(red:0.55,green:0.00,blue:0.00,alpha:1): UIColor.blackColor()
//                color.set()
//                
//                CGContextFillRect(context, CGRectMake(x, y, squareSize, squareSize))
//                
//                
//            
//            
//            
//            }
//            
//            
//        }
//        
//    
//    }
//    
//
//}
