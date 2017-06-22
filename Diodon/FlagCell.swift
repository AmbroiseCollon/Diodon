//
//  FlagCell.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

class FlagCell {
    var cell: Cell

    init(cell: Cell) {
        self.cell = cell
        self.toggleFlagIfNeeded()
    }

    private func toggleFlagIfNeeded() {
        switch cell.state {
        case .hidden:
            flagCell()
        case .flagged:
            hideCell()
        case .revealed, .exploded:
            break
        }
    }

    private func flagCell() {
        cell.state = .flagged
    }

    private func hideCell() {
        cell.state = .hidden
    }
}
