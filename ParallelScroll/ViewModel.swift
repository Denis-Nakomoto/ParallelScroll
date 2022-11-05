//
//  ViewModel.swift
//  ParallelScroll
//
//  Created by Denis Svetlakov on 30.10.2022.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

final class ViewModel: ObservableObject {
    var step: Int?
    var scrollWidth: Int?
    var cardsPosition: [Int] = []
    var cardsIds: [Int] = []
    var cardModel: ContentModel
    
    var delay = false
    var cardsSorted: [Int: Int] = [:]
    
    @Published var currentPosition = 0
    @Published var currentId = 0
    
    // Triggers when block scroll button is pressed
    var scrollTriger = false {
        didSet {
            // This delay is added to have top scroll swith onece and no to switch all top scroll button one by one
            delay = true
            _ = Timer.scheduledTimer(withTimeInterval: 0.5,
                                     repeats: false) { timer in
                self.delay = false
                timer.invalidate()
            }
        }
    }
    
    init() {
        cardModel = ContentModel(blocks: [BlockModel(id: 0, name: "Block1", color: .gray, position: 1,
                                                          contentBlocks: [BlockContentModel(id: 0, name: "Card11"),
                                                                          BlockContentModel(id: 1, name: "Card12"),
                                                                          BlockContentModel(id: 2, name: "Card13")]),
                                               BlockModel(id: 1, name: "Block2", color: .green, position: 2,
                                                          contentBlocks: [BlockContentModel(id: 0, name: "Card21"),
                                                                          BlockContentModel(id: 1, name: "Card22"),
                                                                          BlockContentModel(id: 2, name: "Card23")]),
                                               BlockModel(id: 2, name: "Block3", color: .blue, position: 3,
                                                          contentBlocks: [BlockContentModel(id: 0, name: "Card31"),
                                                                          BlockContentModel(id: 1, name: "Card32"),
                                                                          BlockContentModel(id: 2, name: "Card33"),
                                                                          BlockContentModel(id: 3, name: "Card33")]),
                                               BlockModel(id: 3, name: "Block4", color: .cyan, position: 4,
                                                         contentBlocks: [BlockContentModel(id: 0, name: "Card41"),
                                                                         BlockContentModel(id: 1, name: "Card42"),
                                                                         BlockContentModel(id: 2, name: "Card43"),
                                                                         BlockContentModel(id: 3, name: "Card43")])
         ])
        fillIndexes(content: cardModel)
    }
    
    func onPreferenceChangeHelper(value: CGPoint) {
        if step == nil {
            scrollWidth = Int(value.x + (value.x))
            if let width = scrollWidth, width > 0 {
                let step = width / cardsPosition.count
                self.step = step
            }
        }
        if let currentIndex = scrollData(currentPosition: value.x) {
            if currentIndex <= cardsPosition.count - 1 {
                currentPosition = cardsPosition[currentIndex]
                currentId = cardsIds[currentIndex]
            }
        }
    }
    
    func scrollData(currentPosition: CGFloat) -> Int? {
        if !delay {
            guard let step = step, let totalWidth = scrollWidth else { return 1 }
            var newPositionIndex = 0
            let constantAdd = (totalWidth / 2)
            let currentDifference = totalWidth - (Int(currentPosition) + constantAdd)
            if currentDifference > step {
                newPositionIndex = currentDifference / step
            }
            return newPositionIndex
        }
        return nil
    }
   
    func fillIndexes(content: ContentModel) {
        var blocksCount = 1
        for element in cardModel.blocks.sorted(by: { $0.id < $1.id }) {
            for _ in element.contentBlocks {
                cardsPosition.append(element.position)
                cardsIds.append(element.id)
            }
            cardsSorted[element.id] = blocksCount
            blocksCount += 1
        }
    }

    func scrollTo(value: ScrollViewProxy, position: Int) {
        withAnimation {
            value.scrollTo(position, anchor: .leading)
        }
    }
}

