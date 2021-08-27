//
//  AlertItem.swift
//  TicTacToe
//
//  Created by Chad Smith on 8/26/21.
//

import SwiftUI

struct AlertItem : Identifiable {
    let id: UUID = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"), message: Text("You beat your own AI! Congrats!"), buttonTitle: Text("WoooHoo!"))
    static let computerWin = AlertItem(title: Text("You Lost!"), message: Text("You let the AI Beat you!!"), buttonTitle: Text("I'll try again!"))
    static let draw = AlertItem(title: Text("Draw"), message: Text("What a battle, but CAT won."), buttonTitle: Text("Rematch"))
}
