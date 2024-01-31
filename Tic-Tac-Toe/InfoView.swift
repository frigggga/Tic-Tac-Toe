//
//  InfoView.swift
//  Tic-Tac-Toe
//
//  Created by Zhang on 2024/1/30.
//

import UIKit

class InfoView: UIView {

    @IBOutlet private weak var label: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib();
        layer.backgroundColor = UIColor.white.cgColor
        layer.cornerRadius = 20.0
        layer.borderColor = UIColor.purple.cgColor
        layer.borderWidth = 2.0
    }
    
    func updateText(_ text: String){
        self.alpha = 1
        label.alpha = 1
        label.text = text
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let infoViewHeight = self.bounds.height
        self.frame.origin.y = -infoViewHeight
        self.center.x = screenWidth / 2
        
        UIView.animate(withDuration: 0.5, animations: {
            self.center.y = screenHeight / 2
        })
//
//        let screenHeight = UIScreen.main.bounds.height
//        let infoViewHeight = self.frame.height
//        UIView.animate(withDuration: 0.5, animations: {
//            self.center.y = screenHeight + infoViewHeight / 2
//        }, completion: nil)
    }
 

}
