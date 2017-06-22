//
//  Grid.swift
//  Diodon
//
//  Created by Ambroise COLLON on 20/06/2017.
//  Copyright © 2017 Ambroise Collon. All rights reserved.
//

import Foundation

struct GridIndex {
    var row: Int
    var column: Int

    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}


struct Grid {
    fileprivate var matrix = [[Cell]]()

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
}

// MARK: - Access and modify specific cell
extension Grid {
    func getCellFor(index: GridIndex) -> Cell {
        return matrix[index.row][index.column]
    }

    mutating func set(cell: Cell, forIndex index: GridIndex) {
        matrix[index.row][index.column] = cell
    }
}

// MARK: - Remove first and append row
extension Grid {
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
}

// MARK: - Get neighbours indexes
extension Grid {
    func getNeighboursIndexesFor(index: GridIndex) -> [GridIndex] {
        let ranges = getNeighboursRangesFor(index: index)

        var indexes = [GridIndex]()
        for rowIndex in ranges.rows {
            for columnIndex in ranges.columns {
                if !(rowIndex == index.row && columnIndex == index.column) {
                    indexes.append(GridIndex(rowIndex, columnIndex))
                }
            }
        }

        return indexes
    }

    private func getNeighboursRangesFor(index: GridIndex)
        -> (rows: CountableClosedRange<Int>, columns: CountableClosedRange<Int>) {
            let rowMin = Int.maximum(0, index.row - 1)
            let rowMax = Int.minimum(height - 1, index.row + 1)
            let columnMin = Int.maximum(0, index.column - 1)
            let columnMax = Int.minimum(width - 1, index.column + 1)

            return (rows: rowMin...rowMax, columns: columnMin...columnMax)
    }
}

// MARK: - Calculate all neighboring bomb counts
extension Grid {
    mutating func calculateAllNeighboringBombCounts() {
        for rowIndex in 0..<height {
            for columnIndex in 0..<width {
                calculateAllNeighboringBombCountsForCellAt(index: GridIndex(rowIndex, columnIndex))
            }
        }
    }

    private mutating func calculateAllNeighboringBombCountsForCellAt(index: GridIndex) {
        let neighboringCells = getNeighboringCellsFor(index: index)
        let neighboringBombedCells = neighboringCells.filter { (cell) -> Bool in
            return cell.type == .bomb
        }
        var cell = getCellFor(index: index)
        cell.neighboringBombCount = neighboringBombedCells.count
        set(cell: cell, forIndex: index)
    }


    private func getNeighboringCellsFor(index: GridIndex) -> [Cell] {
        let indexes = getNeighboursIndexesFor(index: index)
        var cells = [Cell]()

        for index in indexes {
            let cell = getCellFor(index: index)
            cells.append(cell)
        }

        return cells
    }
}

// MARK: - Did reveal cell
extension Grid {
    mutating func revealCellAt(index: GridIndex) {
        var cell = getCellFor(index: index)

        switch cell.state {
        case .hidden, .flagged:
            switch cell.type {
            case .bomb:
                cell.state = .exploded
                set(cell: cell, forIndex: index)
            case .plain:
                cell.state = .revealed
                set(cell: cell, forIndex: index)
                if cell.shouldRevealNeighbours {
                    revealNeighboursFor(index: index)
                }
            }
        default:
            break
        }

    }

    private mutating func revealNeighboursFor(index: GridIndex) {
        let indexes = getNeighboursIndexesFor(index: index)
        for neighboorIndex in indexes {
            revealCellAt(index: neighboorIndex)
        }
    }
}
