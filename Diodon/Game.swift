//
//  Game.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

enum GameState {
    case ongoing, over
}

class Game {
    var score = 0
    var grid = Grid(matrix: [[Cell]]())
    var state: GameState = .ongoing

    init(grid: Grid) {
        self.grid = grid
    }

    init() {
    }

    func finish() {
        state = .over
    }

    func incrementScore() {
        score += 1
    }
}
