//
//  Cell.swift
//  Diodon
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

enum CellType {
    case plain, bomb
}

enum CellState {
    case hidden, flagged, revealed, exploded
}

struct Cell {
    let type: CellType
    var state: CellState = .hidden
    var neighboringBombCount = 0

    var shouldRevealNeighbours: Bool {
        return neighboringBombCount == 0
    }

    init(type: CellType) {
        self.state = .hidden
        self.type = type
        self.neighboringBombCount = 0
    }

    init() {
        let types: [CellType] = [.bomb, .plain, .plain]
        let randomIndex = Int.random(upperBound: types.count)
        self.init(type: types[randomIndex])
    }
 }
