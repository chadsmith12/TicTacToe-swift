//
//  PlayerIndicator.swift
//  TicTacToe
//
//  Created by Chad Smith on 8/26/21.
//

import SwiftUI

struct PlayerIndicator: View {
    var systemImage: String
    
    var body: some View {
        Image(systemName: systemImage)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}

struct PlayerIndicator_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            PlayerIndicator(systemImage: "xmark")
            PlayerIndicator(systemImage: "circle")
        }
        .preferredColorScheme(.dark)
    }
}
