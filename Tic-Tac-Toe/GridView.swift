//
//  GridView.swift
//  Tic-Tac-Toe
//
//  Created by Zhang on 2024/1/30.
//

import UIKit

class GridView: UIView {

    override func draw(_ rect: CGRect) {
        let lineWidth: CGFloat = 5.0
        let lineColor: UIColor = .purple

        let path = UIBezierPath()
        path.lineWidth = lineWidth

        let numberOfLines = 2
        let gridGap = 120.0
        
        //vertical lines
        for i in 1...numberOfLines {
            let x = CGFloat(i) * gridGap
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
        }

        //horizontal lines
        for i in 1...numberOfLines {
            let y = CGFloat(i) * gridGap
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
        }

        // Set the stroke color and draw the path
        lineColor.setStroke()
        path.stroke()
            
    }

}

