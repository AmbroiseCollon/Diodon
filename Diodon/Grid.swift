//
//  Grid.swift
//  Diodon
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

struct Grid {
    private var matrix = [[Cell]]()

    var width: Int {
        if let row = matrix.first {
            return row.count
        }
        return 0
    }

    var height: Int {
        return matrix.count
    }

    init(matrix: [[Cell]]) {
        self.matrix = matrix
    }

    init(width: Int, height: Int) {
        let row = Array(repeating: Cell(), count: width)
        self.matrix = Array(repeating: row, count: height)
    }

    // MARK: - Access and modify specific cell
    func getCellFor(row: Int, column: Int) -> Cell {
        return matrix[row][column]
    }

    mutating func set(cell: Cell, forRow row: Int, column: Int) {
        matrix[row][column] = cell
    }

	// MARK: - Remove first and append row
    mutating func removeFirstAndAppendRow() {
        removeFirstRow()
        appendRow()
    }

    private mutating func removeFirstRow() {
        matrix.removeFirst()
    }

    private mutating func appendRow() {
        let newRow = Array(repeating: Cell(), count: width)
        matrix.append(newRow)
    }

    // MARK: - Get neighbours indexes
    func getNeighboursIndexesFor(row: Int, column: Int) -> [(Int, Int)] {
        let ranges = getNeighboursRangesFor(row: row, column: column)

        var indexes = [(Int, Int)]()
        for rowIndex in ranges.rows {
            for columnIndex in ranges.columns {
                if !(rowIndex == row && columnIndex == column) {
                    indexes.append((row: rowIndex, column: columnIndex))
                }
            }
        }

        return indexes
    }

    private func getNeighboursRangesFor(row: Int, column: Int)
        -> (rows: CountableClosedRange<Int>, columns: CountableClosedRange<Int>) {
            let rowMin = Int.maximum(0, row - 1)
            let rowMax = Int.minimum(height - 1, row + 1)
            let columnMin = Int.maximum(0, column - 1)
            let columnMax = Int.minimum(width - 1, column + 1)

            return (rows: rowMin...rowMax, columns: columnMin...columnMax)
    }
}

// MARK: - Calculate all neighboring bomb counts
extension Grid {
    mutating func calculateAllNeighboringBombCounts() {
        for rowIndex in 0..<height {
            for columnIndex in 0..<width {
                calculateAllNeighboringBombCountsForCellAt(row: rowIndex, column: columnIndex)
            }
        }
    }

    private mutating func calculateAllNeighboringBombCountsForCellAt(row: Int, column: Int) {
        let neighboringCells = getNeighboringCellsFor(row: row, column: column)
        let neighboringBombedCells = neighboringCells.filter { (cell) -> Bool in
            return cell.type == .bomb
        }
        var cell = getCellFor(row: row, column: column)
        cell.neighboringBombCount = neighboringBombedCells.count
        set(cell: cell, forRow: row, column: column)
    }


    private func getNeighboringCellsFor(row: Int, column: Int) -> [Cell] {
        let indexes = getNeighboursIndexesFor(row: row, column: column)
        var cells = [Cell]()

        for (rowIndex, columnIndex) in indexes {
            let cell = getCellFor(row: rowIndex, column: columnIndex)
            cells.append(cell)

        }

        return cells
    }
}

// MARK: - Did reveal cell
extension Grid {
    mutating func revealCellAt(row: Int, column: Int) {
        var cell = getCellFor(row: row, column: column)

        switch cell.state {
        case .hidden, .flagged:
            switch cell.type {
            case .bomb:
                cell.state = .exploded
                set(cell: cell, forRow: row, column: column)
            case .plain:
                cell.state = .revealed
                set(cell: cell, forRow: row, column: column)
                if cell.shouldRevealNeighbours {
                    revealNeighboursFor(row: row, column: column)
                }
            }
        default:
            break
        }

    }

    private mutating func revealNeighboursFor(row: Int, column: Int) {
        let indexes = getNeighboursIndexesFor(row: row, column: column)
        for (row, column) in indexes {
            revealCellAt(row: row, column: column)
        }
    }
}
