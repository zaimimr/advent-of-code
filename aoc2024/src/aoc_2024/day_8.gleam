import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string

pub type Position {
  Position(x: Int, y: Int)
}

pub type Antenna {
  Antenna(position: Position, frequency: String)
  Antinode(position: Position, frequency: String)
}

const show_grid = False

pub fn pt_1(input: String) {
  let #(grid, height, width) = get_grid(input)
  let antenna_data = get_antennas(grid)
  let antinodes = get_antinodes(antenna_data, width, height, [1])

  visualize(grid, antenna_data, antinodes, show_grid)
}

pub fn pt_2(input: String) {
  let #(grid, height, width) = get_grid(input)
  let antenna_data = get_antennas(grid)
  let antinodes =
    get_antinodes(
      antenna_data,
      width,
      height,
      list.range(0, int.max(width, height)),
    )

  visualize(grid, antenna_data, antinodes, show_grid)
}

pub fn get_grid(input) {
  let grid =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  let height = list.length(grid)
  let width =
    list.first(grid)
    |> result.unwrap([])
    |> list.length()
  #(grid, height, width)
}

pub fn get_antennas(grid: List(List(String))) -> dict.Dict(Position, Antenna) {
  grid
  |> list.index_fold(dict.new(), fn(acc, line, y) {
    line
    |> list.index_fold(acc, fn(line_acc, char, x) {
      case char {
        "." -> line_acc
        _ ->
          dict.insert(line_acc, Position(x, y), Antenna(Position(x, y), char))
      }
    })
  })
}

pub fn get_antinodes(
  antenna_data: dict.Dict(Position, Antenna),
  width: Int,
  height: Int,
  range: List(Int),
) -> dict.Dict(Position, Antenna) {
  antenna_data
  |> dict.values()
  |> list.group(fn(x) { x.frequency })
  |> dict.values()
  |> list.fold(dict.new(), fn(acc, antenna_group) {
    antenna_group
    |> list.combination_pairs()
    |> list.fold(acc, fn(anti_acc, antennas) {
      let #(antenna_1, antenna_2) = antennas
      let Position(x1, y1) = antenna_1.position
      let Position(x2, y2) = antenna_2.position

      let distance = #(x1 - x2, y1 - y2)
      let anti_acc =
        range
        |> list.fold_until(anti_acc, fn(a, i) {
          let antinode_1 =
            Antinode(Position(x1 + distance.0 * i, y1 + distance.1 * i), "#")
          case
            antinode_1.position.x < 0
            || antinode_1.position.x >= width
            || antinode_1.position.y < 0
            || antinode_1.position.y >= height
          {
            True -> list.Stop(a)
            False ->
              list.Continue(dict.insert(a, antinode_1.position, antinode_1))
          }
        })
      range
      |> list.fold_until(anti_acc, fn(a, i) {
        let antinode_2 =
          Antinode(Position(x2 - distance.0 * i, y2 - distance.1 * i), "#")
        case
          antinode_2.position.x < 0
          || antinode_2.position.x >= width
          || antinode_2.position.y < 0
          || antinode_2.position.y >= height
        {
          True -> list.Stop(a)
          False ->
            list.Continue(dict.insert(a, antinode_2.position, antinode_2))
        }
      })
    })
  })
}

pub fn visualize(
  grid: List(List(String)),
  antenna_data: dict.Dict(Position, Antenna),
  antinodes: dict.Dict(Position, Antenna),
  show_grid: Bool,
) {
  case show_grid {
    True -> {
      io.println("---")
      grid
      |> list.index_map(fn(line, y) {
        let antennas = dict.merge(antenna_data, antinodes)
        line
        |> list.index_map(fn(char, x) {
          let antenna = antennas |> dict.get(Position(x, y))
          case antenna {
            Ok(antenna) -> antenna.frequency
            Error(_) -> char
          }
        })
        |> string.join("")
      })
      |> list.map(io.println)
      io.println("---")
    }
    False -> Nil
  }
  antinodes |> dict.values() |> list.length
}
