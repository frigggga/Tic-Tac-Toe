//
//  ViewController.swift
//  Tic-Tac-Toe
//
//  Created by Zhang on 2024/1/30.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var infoView: InfoView!
    @IBAction func infoButton(_ sender: Any) {
        infoView.updateText("Get 3 in a row to win! ")
    }
    
    @IBAction func button(_ sender: Any) {
        if self.grid.winner != "E" || self.grid.checkTie() {
            self.resetGame()
        }

        let screenHeight = UIScreen.main.bounds.height
        let infoViewHeight = self.infoView.frame.height
        
        // Animate the info view falling off the screen
        UIView.animate(withDuration: 0.5, animations: {
            self.infoView.center.y = screenHeight + infoViewHeight / 2
        }) { _ in
            // After the animation completes, reposition the view above the screen
            self.infoView.frame.origin.y = -infoViewHeight
        }
    }
    
    @IBOutlet weak var pieceX: UILabel!
    @IBOutlet weak var pieceO: UILabel!
    @IBOutlet var squares: [UIView]!
    
    let grid: Grid = Grid()
    
    let xPos = CGPoint(x: 53 + 50, y: 727 + 50)
    let oPos = CGPoint(x: 265 + 50, y: 727 + 50)
    
    var lineLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up initial gesture and pieces
        let gestureX = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pieceX.addGestureRecognizer(gestureX)
        
        let gestureO = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pieceO.addGestureRecognizer(gestureO)
        
        pieceX.isUserInteractionEnabled = true
        pieceO.isUserInteractionEnabled = false
        pieceX.alpha = 1
        pieceO.alpha = 0.5
        
        self.view.bringSubviewToFront(self.infoView)
        self.infoView.alpha = 0
        
        
        

    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let pieceView = recognizer.view as? UILabel else
            {return}
        
        switch recognizer.state {
        case .began, .changed:
                let translation = recognizer.translation(in: self.view)
                recognizer.view?.center.x += translation.x
                recognizer.view?.center.y += translation.y
                recognizer.setTranslation(.zero, in: self.view)
            
        case .ended:
            if let targetSquare = findTargetSquare(forPiece: pieceView) {
                // place the target square in grid
                pieceView.center = targetSquare.center
                let copyPiece = self.generateCopy(from: pieceView)
                self.view.insertSubview(copyPiece, belowSubview: self.infoView)
                self.grid.addSquare(at: targetSquare.tag)
                pieceView.isUserInteractionEnabled = false // disable interaction if placed
                
                // a player wins
                if self.grid.checkWin()  {
                    drawLine()
                    
                // there is a tie
                } else if self.grid.checkTie() {
                    self.infoView.updateText("There is a tie.")
                    
                // continue playing the game, switch to the next player
                } else {
                    changePlayer()
                }
            }
            // animate back to starting position if the place is occupied or out of grid
            UIView.animate(withDuration: 0.3) {
                if pieceView == self.pieceX{
                    pieceView.center = self.xPos
                }else {
                    pieceView.center = self.oPos
                }
               
            }
            
        default:
            break
        }
    }
    
    func findTargetSquare(forPiece piece: UIView) -> UIView? {
        for (index, square) in self.squares.enumerated() {
            if square.frame.intersects(piece.frame) && !self.grid.squares[index].isOccupied {
                return square
            }
        }
        return nil
    }
    
    
        
    
    func generateCopy(from piece: UILabel) ->UILabel {
        let copy = UILabel(frame: piece.frame)
        
        copy.text = piece.text
        copy.textAlignment = piece.textAlignment
        copy.textColor = piece.textColor
        copy.font = piece.font
        copy.backgroundColor = piece.backgroundColor
        copy.tag = 100
        
        return copy
        
    }
    
    func changePlayer(){
        let duration: TimeInterval = 1
        let scaleUpFactor: CGFloat = 1.5
        
        if(self.grid.curPlayer == "X"){
            pieceX.isUserInteractionEnabled = false
            self.grid.curPlayer = "O"
            pieceO.alpha = 1
            pieceX.alpha = 0.5
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
                // Add keyframe for scaling up
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2) {
                    self.pieceO.transform = CGAffineTransform(scaleX: scaleUpFactor, y: scaleUpFactor)
                }
                
                // Add keyframe for scaling down
                UIView.addKeyframe(withRelativeStartTime: duration / 2, relativeDuration: duration / 2) {
                    self.pieceO.transform = .identity
                }
                
            })
            pieceO.isUserInteractionEnabled = true
            
        }else{
            pieceO.isUserInteractionEnabled = false
            self.grid.curPlayer = "X"
            pieceX.alpha = 1
            pieceO.alpha = 0.5
            
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
                // add keyframe for scaling up
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration / 2) {
                    self.pieceX.transform = CGAffineTransform(scaleX: scaleUpFactor, y: scaleUpFactor)
                }
                
                // add keyframe for scaling down
                UIView.addKeyframe(withRelativeStartTime: duration / 2, relativeDuration: duration / 2) {
                    self.pieceX.transform = .identity
                }
                
            })
            pieceX.isUserInteractionEnabled = true
        }
        
    }

    
    func resetGame() {
        self.grid.clearBoard()
        
        pieceX.isUserInteractionEnabled = true
        pieceO.isUserInteractionEnabled = false
        pieceX.alpha = 1
        pieceO.alpha = 0.5
        
        self.view.bringSubviewToFront(self.infoView)
        
        for v in view.subviews{
            if v.tag == 100 {
                v.removeFromSuperview()
            }
        }
        self.lineLayer.removeFromSuperlayer()
        
    }
    
    func drawLine() {
        let startPoint = self.squares[self.grid.line[0]].center
        let endPoint = self.squares[self.grid.line[2]].center

        let linePath = UIBezierPath()
        linePath.move(to: startPoint)
        linePath.addLine(to: endPoint)
  

        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.lineWidth = 5
        lineLayer.fillColor = nil

        self.view.layer.addSublayer(lineLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        self.view.bringSubviewToFront(self.infoView)
        lineLayer.add(animation, forKey: "lineAnimation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            self.infoView.updateText("Congratulations, player \(self.grid.winner) wins! ")
        }
        
    }

}

