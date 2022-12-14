//
//  ScrollsView.swift
//  ParallelScroll
//
//  Created by Denis Svetlakov on 30.10.2022.
//

import SwiftUI

struct ScrollsView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            blocksScroll()
                .padding(.top, 30)
            cardsScroll()
            Spacer()
        }
        .padding(.bottom, 15)
    }
    
    private func blocksScroll() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                HStack {
                    ForEach(viewModel.cardModel.blocks.sorted(by: { $0.id < $1.id }),
                            id: \.id) { block in
                        Button {
                            viewModel.currentPosition = block.position
                            viewModel.currentId = block.id
                            viewModel.scrollTriger.toggle()
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(viewModel.currentId == block.id ? Color.clear :
                                                Color.blue, lineWidth: 1)
                                    .background(viewModel.currentId == block.id ? Color.blue : Color.clear)
                                    .cornerRadius(20)
                                Text("Block \(String(describing: block.position))")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color.green)
                            }
                            .frame(width: 120, height: 40)
                        }
                        .offset(x: 15)
                        .padding(.trailing, 15)
                    }
                            .onChange(of: viewModel.currentId) { _ in
                                viewModel.scrollTo(value: value, position: viewModel.currentId)
                            }
                }
            }
        }
    }
    
    private func cardsScroll() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                // 1
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: ScrollPreferenceKey.self,
                        value: geometry.frame(in: .global).origin
                    )
                }.frame(width: 0, height: 0)
                HStack {
                    ForEach(viewModel.cardModel.blocks.sorted(by: { $0.position < $1.position }),
                            id: \.id) { block in
                        HStack {
                            ForEach(block.contentBlocks, id: \.id) { card in
                                Card(block: card, blockName: block.name, color: block.color)
                                    .id(card.id)
                            }
                        }
                    }
                            .onChange(of: viewModel.scrollTriger) { _ in
                                viewModel.scrollTo(value: value, position: viewModel.currentId)
                            }
                }
            }
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            viewModel.onPreferenceChangeHelper(value: value)
        }
    }
}

