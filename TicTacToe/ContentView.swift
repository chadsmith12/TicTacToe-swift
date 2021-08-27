//
//  ContentView.swift
//  TicTacToe
//
//  Created by Chad Smith on 8/25/21.
//

import SwiftUI

struct ContentView: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let middleSquare = 4
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn = true
    @State private var isGameBoardDisabled = false
    @State private var alertItem: AlertItem? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width / 3 - 15, height: geometry.size.height / 3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isSquareOccupied(in: moves, forIndex: i) {
                                return
                            }
                            moves[i] = Move(player: .human, boardIndex: i)
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
                                let computerPosition = determineMovePosition(in: moves)
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                if checkWinCondition(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .disabled(isGameBoardDisabled)
            .alert(item: $alertItem) { alert in
                Alert(title: alert.title, message: alert.message, dismissButton: .default(alert.buttonTitle, action: resetGame))
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

enum Player {
    case human
    case computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
