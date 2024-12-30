import gleam/dict
import gleam/list
import gleam/result
import gleam/string

pub type Direction {
  North
  East
  South
  West
}

pub type Cell {
  Floor(x: Int, y: Int)
  Wall(x: Int, y: Int)
  Guard(x: Int, y: Int, direction: Direction)
}

pub fn turn_right(direction: Direction) -> Direction {
  case direction {
    North -> East
    East -> South
    South -> West
    West -> North
  }
}

pub fn move_forward(x: Int, y: Int, direction: Direction) -> #(Int, Int) {
  case direction {
    North -> #(x, y - 1)
    East -> #(x + 1, y)
    South -> #(x, y + 1)
    West -> #(x - 1, y)
  }
}

fn move(grid, position, direction, visited) {
  let #(x, y) = position
  let next_position = move_forward(x, y, direction)
  case !dict.has_key(grid, next_position) {
    True -> visited
    False -> {
      let cell = dict.get(grid, next_position) |> result.unwrap(Wall(0, 0))
      case cell {
        Wall(_, _) -> move(grid, position, turn_right(direction), visited)
        _ ->
          move(
            grid,
            next_position,
            direction,
            dict.insert(visited, next_position, True),
          )
      }
    }
  }
}

pub fn pt_1(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.index_fold(dict.new(), fn(grid, line, y) {
      line
      |> string.to_graphemes()
      |> list.index_fold(dict.new(), fn(acc_grid, char, x) {
        case char {
          "." -> dict.insert(acc_grid, #(x, y), Floor(x, y))
          "#" -> dict.insert(acc_grid, #(x, y), Wall(x, y))
          "^" -> dict.insert(acc_grid, #(x, y), Guard(x, y, North))
          "<" -> dict.insert(acc_grid, #(x, y), Guard(x, y, West))
          ">" -> dict.insert(acc_grid, #(x, y), Guard(x, y, East))
          "v" -> dict.insert(acc_grid, #(x, y), Guard(x, y, South))
          _ -> acc_grid
        }
      })
      |> dict.merge(grid)
    })

  let guard_position =
    grid
    |> dict.fold(#(0, 0), fn(acc, key, value) {
      case value {
        Guard(_, _, _) -> key
        _ -> acc
      }
    })
  let guard =
    dict.get(grid, guard_position) |> result.unwrap(Guard(0, 0, North))

  let direction = case guard {
    Guard(_, _, dir) -> dir
    _ -> panic
  }

  let visited = dict.new() |> dict.insert(guard_position, True)

  move(grid, guard_position, direction, visited)
  |> dict.to_list()
  |> list.length()
}

pub fn simulate(grid, position, direction, visited_states) -> Bool {
  let #(x, y) = position
  let next_position = move_forward(x, y, direction)
  let state = #(position, direction)

  case dict.has_key(visited_states, state) {
    True -> True
    False -> {
      let new_visited_states = dict.insert(visited_states, state, True)
      case !dict.has_key(grid, next_position) {
        True -> False
        False -> {
          let cell = dict.get(grid, next_position) |> result.unwrap(Wall(0, 0))
          case cell {
            Wall(_, _) ->
              simulate(
                grid,
                position,
                turn_right(direction),
                new_visited_states,
              )
            _ -> simulate(grid, next_position, direction, new_visited_states)
          }
        }
      }
    }
  }
}

pub fn is_guard_stuck(grid, position, direction) -> Bool {
  let visited_states = dict.new()
  simulate(grid, position, direction, visited_states)
}

pub fn pt_2(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.index_fold(dict.new(), fn(grid, line, y) {
      line
      |> string.to_graphemes()
      |> list.index_fold(dict.new(), fn(acc_grid, char, x) {
        case char {
          "." -> dict.insert(acc_grid, #(x, y), Floor(x, y))
          "#" -> dict.insert(acc_grid, #(x, y), Wall(x, y))
          "^" -> dict.insert(acc_grid, #(x, y), Guard(x, y, North))
          "<" -> dict.insert(acc_grid, #(x, y), Guard(x, y, West))
          ">" -> dict.insert(acc_grid, #(x, y), Guard(x, y, East))
          "v" -> dict.insert(acc_grid, #(x, y), Guard(x, y, South))
          _ -> acc_grid
        }
      })
      |> dict.merge(grid)
    })

  let guard_position =
    grid
    |> dict.fold(#(0, 0), fn(acc, key, value) {
      case value {
        Guard(_, _, _) -> key
        _ -> acc
      }
    })

  let guard =
    dict.get(grid, guard_position) |> result.unwrap(Guard(0, 0, North))

  let direction = case guard {
    Guard(_, _, dir) -> dir
    _ -> panic
  }

  let valid_positions =
    grid
    |> dict.to_list()
    |> list.filter(fn(item) {
      let #(pos, cell) = item
      case cell {
        Floor(_, _) -> pos != guard_position
        _ -> False
      }
    })

  valid_positions
  |> list.map(fn(item) {
    let #(pos, _) = item
    let grid_with_obstruction = dict.insert(grid, pos, Wall(pos.0, pos.1))
    is_guard_stuck(grid_with_obstruction, guard_position, direction)
  })
  |> list.filter(fn(is_stuck) { is_stuck })
  |> list.length()
}
