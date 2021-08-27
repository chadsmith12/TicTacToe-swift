//
//  Move.swift
//  TicTacToe
//
//  Created by Chad Smith on 8/26/21.
//

import Foundation

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
