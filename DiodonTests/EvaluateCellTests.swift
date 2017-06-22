//
//  EvaluateCellTests.swift
//  Diodon
//
//  Created by Ambroise COLLON on 22/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import Diodon

class EvaluateCellTests: XCTestCase {
    let cell = Cell()
    let game = Game()
    var evaluateCell = EvaluateCell(cell: Cell(), forGame: Game())

    override func setUp() {
        super.setUp()
        evaluateCell = EvaluateCell(cell: cell, forGame: game)
    }
    
    func testGivenCellStateIsHidden_WhenEvaluatingIt_GameShouldFinish() {
        cell.state = .hidden
        evaluateCell.execute()
        XCTAssertEqual(game.state, .over)
    }

    func testGivenCellStateIsExploded_WhenEvaluatingIt_GameShouldFinish() {
        cell.state = .exploded
        evaluateCell.execute()
        XCTAssertEqual(game.state, .over)
    }

    func testGivenCellStateIsRevealed_WhenEvaluatingIt_GameShouldKeepGoing() {
        cell.state = .revealed
        evaluateCell.execute()
        XCTAssertEqual(game.state, .ongoing)
    }

    func testGivenCellStateIsFlaggedAndHasABomb_WhenEvaluatingIt_GameScoreShouldIncrement() {
        cell.state = .flagged
        cell.type = .bomb
        evaluateCell.execute()
        XCTAssertEqual(game.state, .ongoing)
        XCTAssertEqual(game.score, 1)
    }

    func testGivenCellStateIsFlaggedAndHasNoBomb_WhenEvaluatingIt_GameShouldFinish() {
        cell.state = .flagged
        cell.type = .plain
        evaluateCell.execute()
        XCTAssertEqual(game.state, .over)
    }
}
