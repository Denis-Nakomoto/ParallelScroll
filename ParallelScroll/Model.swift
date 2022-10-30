//
//  Model.swift
//  ParallelScroll
//
//  Created by Denis Svetlakov on 30.10.2022.
//

import SwiftUI

struct ContentModel {
    var blocks: [BlockModel]
}

struct BlockModel {
    let id: Int
    let name: String
    let color: Color
    let position: Int
    var contentBlocks: [BlockContentModel]
}

struct BlockContentModel {
    var id: Int
    var name: String
}
