//
//  GameSquareView.swift
//  TicTacToe
//
//  Created by Chad Smith on 8/26/21.
//

import SwiftUI

struct GameSquareView: View {
    var proxy: GeometryProxy
    
    var body: some View {
        Circle()
            .foregroundColor(.red).opacity(0.5)
            .frame(width: proxy.size.width / 3 - 15, height: proxy.size.height / 3 - 15)
    }
}

struct GameSquareView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            VStack {
                GameSquareView(proxy: proxy)
            }
        }
    }
}
