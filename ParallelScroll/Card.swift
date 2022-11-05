//
//  Card.swift
//  ParallelScroll
//
//  Created by Denis Svetlakov on 30.10.2022.
//

import SwiftUI

struct Card: View {
    
    var block: BlockContentModel
    var blockName: String
    var color: Color
    
    init(block: BlockContentModel, blockName: String, color: Color) {
        self.block = block
        self.blockName = blockName
        self.color = color
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 300, height: 300)
                    .foregroundColor(color)
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(blockName)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Text(block.name)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 30)
                    Spacer()
                }
            }
            .padding(.top, 10)
            .padding(.leading, 15)
        }
        .frame(width: 310, height: 310)
        .padding(.leading, 15)
    }
}
