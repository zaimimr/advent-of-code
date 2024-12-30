import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Pos {
  Pos(x: Int, y: Int)
}

pub type Cell {
  Cell(pos: Pos, value: String, visited: Bool, walls: Int, group: String)
}

pub fn parse_input(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.index_map(fn(row, y) {
    row
    |> list.index_fold([], fn(acc, cell, x) {
      let pos = Pos(x, y)
      acc |> list.append([#(pos, Cell(pos, cell, False, 0, ""))])
    })
  })
  |> list.flatten()
}

pub fn check_neighbors(cell: #(Pos, Cell), cells: List(#(Pos, Cell))) {
  let neighbors = [
    Pos({ cell.0 }.x, { cell.0 }.y - 1),
    Pos({ cell.0 }.x, { cell.0 }.y + 1),
    Pos({ cell.0 }.x - 1, { cell.0 }.y),
    Pos({ cell.0 }.x + 1, { cell.0 }.y),
  ]
  neighbors
  |> list.filter_map(fn(pos) {
    cells
    |> list.key_find(pos)
  })
  |> list.map(fn(neighbor) { #(neighbor.pos, neighbor) })
  |> list.filter(fn(neighbor) { { neighbor.1 }.value == { cell.1 }.value })
}

fn is_corner(first: Bool, second: Bool, diag: Bool) -> Int {
  case first, second, diag {
    True, True, True -> 0
    False, True, True -> 1
    True, False, True -> 1
    True, True, False -> 1

    False, False, False -> 0
    True, False, False -> 0
    False, True, False -> 0
    False, False, True -> 1
  }
}

fn check_corner(cell: Cell, first: Cell, second: Cell, diag: Cell) -> Int {
  let first_match = first.value == cell.value && first.group == cell.group
  let second_match = second.value == cell.value && second.group == cell.group
  let diag_match = diag.value == cell.value && diag.group == cell.group

  is_corner(first_match, second_match, diag_match)
}

pub fn check_corners(cell: #(Pos, Cell), cells: List(#(Pos, Cell))) {
  let corner_neighbors = [
    #(
      Pos({ cell.0 }.x + 1, { cell.0 }.y),
      Pos({ cell.0 }.x, { cell.0 }.y + 1),
      Pos({ cell.0 }.x + 1, { cell.0 }.y + 1),
    ),
    #(
      Pos({ cell.0 }.x - 1, { cell.0 }.y),
      Pos({ cell.0 }.x, { cell.0 }.y + 1),
      Pos({ cell.0 }.x - 1, { cell.0 }.y + 1),
    ),
    #(
      Pos({ cell.0 }.x + 1, { cell.0 }.y),
      Pos({ cell.0 }.x, { cell.0 }.y - 1),
      Pos({ cell.0 }.x + 1, { cell.0 }.y - 1),
    ),
    #(
      Pos({ cell.0 }.x - 1, { cell.0 }.y),
      Pos({ cell.0 }.x, { cell.0 }.y - 1),
      Pos({ cell.0 }.x - 1, { cell.0 }.y - 1),
    ),
  ]

  corner_neighbors
  |> list.map(fn(corners) {
    let first =
      cells
      |> list.key_find(corners.0)
      |> result.unwrap(Cell(Pos(-1, -1), "", False, 0, ""))
    let second =
      cells
      |> list.key_find(corners.1)
      |> result.unwrap(Cell(Pos(-1, -1), "", False, 0, ""))
    let diag =
      cells
      |> list.key_find(corners.2)
      |> result.unwrap(Cell(Pos(-1, -1), "", False, 0, ""))

    check_corner(cell.1, first, second, diag)
  })
  |> list.reduce(int.add)
  |> result.unwrap(0)
}

pub fn solve(cell: #(Pos, Cell), cells: List(#(Pos, Cell))) {
  let neighbors = check_neighbors(cell, cells)
  let group_name = case
    neighbors
    |> list.filter(fn(neighbor) { { neighbor.1 }.group != "" })
    |> list.first()
  {
    Ok(neighbor) -> { neighbor.1 }.group
    Error(_) -> {
      string.concat([
        { cell.1 }.value,
        { cell.0 }.x |> int.to_string,
        ", ",
        { cell.0 }.y |> int.to_string,
      ])
    }
  }

  let cell =
    Cell(
      { cell.1 }.pos,
      { cell.1 }.value,
      True,
      4 - list.length(neighbors),
      group_name,
    )

  let cells = cells |> list.key_set(cell.pos, cell)
  neighbors
  |> list.fold(cells, fn(acc, neighbor) {
    case { neighbor.1 }.visited {
      True -> acc
      False -> {
        solve(neighbor, acc)
      }
    }
  })
}

pub fn solve2(cell: #(Pos, Cell), cells: List(#(Pos, Cell))) {
  let neighbors = check_neighbors(cell, cells)
  let group_name = case
    neighbors
    |> list.filter(fn(neighbor) { { neighbor.1 }.group != "" })
    |> list.first()
  {
    Ok(neighbor) -> { neighbor.1 }.group
    Error(_) -> {
      string.concat([
        { cell.1 }.value,
        { cell.0 }.x |> int.to_string,
        ", ",
        { cell.0 }.y |> int.to_string,
      ])
    }
  }

  let cell = Cell({ cell.1 }.pos, { cell.1 }.value, True, 0, group_name)

  let cells = cells |> list.key_set(cell.pos, cell)
  neighbors
  |> list.fold(cells, fn(acc, neighbor) {
    case { neighbor.1 }.visited {
      True -> acc
      False -> {
        solve(neighbor, acc)
      }
    }
  })
}

pub fn pt_1(input: String) {
  parse_input(input)
  |> list.first()
  // cells
  // |> list.fold(cells, fn(acc, cell) {
  //   case acc |> list.key_find(cell.0) {
  //     Ok(c) ->
  //       case c.visited {
  //         True -> acc
  //         False -> {
  //           solve(cell, acc)
  //         }
  //       }
  //     Error(_) -> acc
  //   }
  // })
  // |> list.group(fn(cell) { { cell.1 }.group })
  // |> dict.values()
  // |> list.map(fn(group) {
  //   let area = group |> list.length
  //   let sum_walls =
  //     group |> list.fold(0, fn(acc, cell) { acc + { cell.1 }.walls })

  //   let group_name = case
  //     group
  //     |> list.first()
  //   {
  //     Ok(x) -> { x.1 }.group
  //     Error(_) -> panic
  //   }
  //   #(group_name, area, sum_walls)
  // })
  // |> list.fold(0, fn(acc, item) {
  //   let #(_group_name, area, sum_walls) = item
  //   acc + area * sum_walls
  // })
}

pub fn pt_2(input: String) {
  let cells = parse_input(input)
  let cells =
    cells
    |> list.fold(cells, fn(acc, cell) {
      case acc |> list.key_find(cell.0) {
        Ok(c) ->
          case c.visited {
            True -> acc
            False -> {
              solve2(cell, acc)
            }
          }
        Error(_) -> acc
      }
    })

  cells
  |> list.map(fn(cell) {
    let count = check_corners(cell, cells)
    #(
      cell.0,
      Cell(
        { cell.1 }.pos,
        { cell.1 }.value,
        { cell.1 }.visited,
        count,
        { cell.1 }.group,
      ),
    )
  })
  |> list.group(fn(cell) { { cell.1 }.group })
  |> dict.values()
  |> list.map(fn(group) {
    let area = group |> list.length
    let sum_walls =
      group |> list.fold(0, fn(acc, cell) { acc + { cell.1 }.walls })

    let group_name = case
      group
      |> list.first()
    {
      Ok(x) -> { x.1 }.group
      Error(_) -> panic
    }
    #(group_name, area, sum_walls)
  })
  |> list.fold(0, fn(acc, item) {
    let #(_group_name, area, sum_walls) = item
    acc + area * sum_walls
  })
}
