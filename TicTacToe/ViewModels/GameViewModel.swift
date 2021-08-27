//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by Chad Smith on 8/26/21.
//

import SwiftUI

final class GameViewModel : ObservableObject {
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let middleSquare = 4
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isHumanTurn = true
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem? = nil
    
    func processPlayerMove(for position: Int) {
        if isSquareOccupied(in: moves, forIndex: position) {
            return
        }
        moves[position] = Move(player: .human, boardIndex: position)
        isGameBoardDisabled = true
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        if checkForDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let computerPosition = self.determineMovePosition(in: self.moves)
            self.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            self.isGameBoardDisabled = false
            if self.checkWinCondition(for: .computer, in: self.moves) {
                self.alertItem = AlertContext.computerWin
                return
            }
            if self.checkForDraw(in: self.moves) {
                self.alertItem = AlertContext.draw
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineMovePosition(in moves: [Move?]) -> Int {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6,7,8],
                                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                                          [0, 4, 8], [2, 4, 6]]
        
        // check to see  if they can win
        let computerPositions = getMovePositions(for: .computer)
        for winPattern in winPatterns {
            let winPositions  = winPattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: winPositions.first!) {
                    return winPositions.first!
                }
            }
        }
        
        // check to see if they can block a win
        let playerPositions = getMovePositions(for: .human)
        for winPattern in winPatterns {
            let blockPositions =  winPattern.subtracting(playerPositions)
            if blockPositions.count == 1 {
                if !isSquareOccupied(in: moves, forIndex: blockPositions.first!) {
                    return blockPositions.first!
                }
            }
        }
        
        // check to see if the middle square is left
        if !isSquareOccupied(in: moves, forIndex: middleSquare) {
            return middleSquare
        }
        
        var movePosition = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6,7,8],
                                          [0, 3, 6], [1, 4, 7], [2, 5, 8],
                                          [0, 4, 8], [2, 4, 6]]
        let playerPositions = getMovePositions(for: player)
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func getMovePositions(for player: Player) -> Set<Int> {
        let currentMoves = moves.compactMap({$0}).filter({$0.player == player})
        
        return Set(currentMoves.map({$0.boardIndex}))
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        moves.compactMap({$0}).count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isGameBoardDisabled = false
    }
}
