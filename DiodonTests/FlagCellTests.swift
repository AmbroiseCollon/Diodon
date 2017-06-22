//
//  FlagCellTest.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import Diodon

class FlagCellTests: XCTestCase {

    func testGivenCellIsHidden_WhenFlaggingIt_ThenStateIsFlagged() {
        let cell = Cell()
        let flagCell = FlagCell(cell: cell)
        flagCell.execute()
        XCTAssertEqual(cell.state, .flagged)
    }

    func testGivenCellIsFlagged_WhenFlaggingIt_ThenStateIsHidden() {
        let cell = Cell()
        cell.state = .flagged

        let flagCell = FlagCell(cell: cell)
        flagCell.execute()

        XCTAssertEqual(cell.state, .hidden)
    }

    func testGivenCellIsRevealedOrExploded_WhenFlaggingIt_ThenStateIsNotChanged() {
        let cell1 = Cell()
        cell1.state = .revealed
        let cell2 = Cell()
        cell2.state = .exploded

        let flagCell = FlagCell(cell: cell1)
        flagCell.execute()

        flagCell.cell = cell2
        flagCell.execute()

        XCTAssertEqual(cell1.state, .revealed)
        XCTAssertEqual(cell2.state, .exploded)
    }    
}
