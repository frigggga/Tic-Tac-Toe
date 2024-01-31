//
//  Grid.swift
//  Tic-Tac-Toe
//
//  Created by Zhang on 2024/1/30.
//

import Foundation

class Grid {
    var squares:[Square]
    var curPlayer: String
    var numOccupied: Int
    var winner: String
    var line: [Int]
    let win: [[Int]]
    
    init() {
        self.squares = [Square]()
        for _ in 0...8 {
            self.squares.append(Square())
        }
        curPlayer = "X"
        numOccupied = 0
        win = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        line = [-1, -1, -1]
        winner = "E"
    }
    
    func clearBoard(){
        self.squares = [Square]()
        for _ in 0...8 {
            self.squares.append(Square())
        }
        curPlayer = "X"
        numOccupied = 0
        line = [-1, -1, -1]
        winner = "E"
    }
    
    func addSquare(at position: Int) {
        if self.squares[position].isOccupied {
            return
        }else {
            self.squares[position].player = curPlayer
            self.squares[position].isOccupied = true
            numOccupied += 1
        }
    }
    
    
    func checkWin() -> Bool {
        for i in 1..<self.win.count {
            let pattern = win[i]
            if squares[pattern[0]].player != "E" && squares[pattern[0]].player == squares[pattern[1]].player && squares[pattern[1]].player == squares[pattern[2]].player{
                self.winner = squares[pattern[0]].player
                self.line = pattern
                return true
            }
        }
        return false
        
    }
    
    func checkTie() -> Bool {
        if numOccupied == 9 {
            return true
        }else {
            return false
        }
    }
    
    
}

struct Square {
    var player: String
    var isOccupied: Bool
    
    init() {
        self.player = "E"
        self.isOccupied = false
    }
}
