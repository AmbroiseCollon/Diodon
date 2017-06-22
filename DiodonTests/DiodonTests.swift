//
//  DiodonTests.swift
//  DiodonTests
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import XCTest
@testable import Diodon

class DiodonTests: XCTestCase {

    var grid = Grid(width: 0, height: 0)

    override func setUp() {
        super.setUp()
        grid = Grid(matrix: [
            [Cell(type: .bomb), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .bomb), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .plain), Cell(type: .plain), Cell(type: .plain)],
            [Cell(type: .plain), Cell(type: .plain), Cell(type: .bomb)],
            ])
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWhenCreatingCell_TypeStateAndBombCountIsOK() {
        let cell = Cell()
        XCTAssertNotNil(cell)
        XCTAssert(cell.type == .plain || cell.type == .bomb)
        XCTAssertEqual(cell.state, .hidden)
        XCTAssertEqual(cell.neighboringBombCount, 0)
    }

    func testWhenCreatingGrid_WidthAndHeightAreOk() {
        XCTAssertNotNil(grid)
        XCTAssertEqual(grid.width, 3)
        XCTAssertEqual(grid.height, 4)
    }

    func testWhenRemovingFirstRowAndAppendingNewRow_ThenHeightRemainsConstant() {
        var customGrid = Grid(width: 7, height: 10)
        customGrid.removeFirstAndAppendRow()
        XCTAssertEqual(customGrid.height, 10)
    }

    func testWhenCalculatingBombCounts_TheyAreAllOK() {
        grid.calculateAllNeighboringBombCounts()

        var result = [Int]()
        for row in 0..<grid.height {
            for column in 0..<grid.width {
                let bombCount = grid.getCellFor(index: GridIndex(row, column)).neighboringBombCount
                result.append(bombCount)
            }
        }

        let expected = [
            1,2,0,
            1,2,0,
            1,2,1,
            0,1,0
        ]

        XCTAssertEqual(expected, result)
    }


    func testGivenCellContainsABomb_WhenRevealingIt_ThenItExplodes() {
        grid.revealCellAt(index: GridIndex(0, 0))
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 0)).state, .exploded)
    }

    func testGivenCellIsEmptyAndNextToABomb_WhenRevealingIt_ThenItRevealsIt() {
        grid.calculateAllNeighboringBombCounts()
        grid.revealCellAt(index: GridIndex(0, 1))
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 1)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(0, 0)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(0, 2)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 0)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 1)).state, .revealed)
        XCTAssertNotEqual(grid.getCellFor(index: GridIndex(1, 2)).state, .revealed)
    }

    func testGivenCellIsEmptyAndHasNoBombNextToIt_WhenRevealingIt_ThenItRevealsTheCellAndTheOnesArroundItAsWell() {
        grid.calculateAllNeighboringBombCounts()
        grid.revealCellAt(index: GridIndex(0, 2))
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 2)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(0, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(1, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(1, 2)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(2, 1)).state, .revealed)
        XCTAssertEqual(grid.getCellFor(index: GridIndex(2, 2)).state, .revealed)
    }
}
