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
    let cell = Cell()
    var flagCell = FlagCell(cell: Cell())

    override func setUp() {
        flagCell = FlagCell(cell: cell)
    }

    func testGivenCellIsHidden_WhenFlaggingIt_ThenStateIsFlagged() {
        cell.state = .hidden
        flagCell.execute()
        XCTAssertEqual(cell.state, .flagged)
    }

    func testGivenCellIsFlagged_WhenFlaggingIt_ThenStateIsHidden() {
        cell.state = .flagged
        flagCell.execute()
        XCTAssertEqual(cell.state, .hidden)
    }

    func testGivenCellIsRevealed_WhenFlaggingIt_ThenStateIsNotChanged() {
        cell.state = .revealed
        flagCell.execute()
        XCTAssertEqual(cell.state, .revealed)

    }

    func testGivenCellIsExploded_WhenFlaggingIt_ThenStateIsNotChanged() {
        cell.state = .exploded
        flagCell.execute()
        XCTAssertEqual(cell.state, .exploded)
    }    
}
