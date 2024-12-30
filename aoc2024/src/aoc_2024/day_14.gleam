import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import utils

pub type Robot {
  Robot(x: Int, y: Int, vx: Int, vy: Int)
}

pub fn safe_option_int(s) {
  s
  |> option.unwrap("0")
  |> utils.safe_int
}

pub fn pt_1(input: String) {
  let robots =
    input
    |> string.split("\n")
    |> list.map(fn(row) {
      let assert Ok(re) =
        regexp.from_string("p=(-?\\d*),(-?\\d*) v=(-?\\d*),(-?\\d*)")
      case regexp.scan(with: re, content: row) |> list.first() {
        Ok(data) -> {
          let assert [x, y, vx, vy] = data.submatches
          Robot(
            x |> safe_option_int,
            y |> safe_option_int,
            vx |> safe_option_int,
            vy |> safe_option_int,
          )
        }
        Error(_) -> panic
      }
    })

  let max_width = 101
  let max_height = 103

  let lower_half_max_width = max_width / 2 - 1
  let higher_half_max_width = max_width - max_width / 2
  let lower_half_max_height = max_height / 2 - 1
  let higher_half_max_height = max_height - max_height / 2
  let quadrents = [
    #(#(0, lower_half_max_width), #(0, lower_half_max_height), []),
    #(#(higher_half_max_width, max_width - 1), #(0, lower_half_max_height), []),
    #(#(0, lower_half_max_width), #(higher_half_max_height, max_height - 1), []),
    #(
      #(higher_half_max_width, max_width - 1),
      #(higher_half_max_height, max_height - 1),
      [],
    ),
  ]
  let updated_robots =
    list.range(1, 100)
    |> list.fold(robots, fn(state, idx) {
      let new_state =
        state
        |> list.map(fn(robot) {
          let new_x = robot.x + robot.vx
          let new_x = case new_x < 0, new_x >= max_width {
            True, False -> new_x + max_width
            False, True -> new_x - max_width
            False, False -> new_x
            _, _ -> panic
          }
          let new_y = robot.y + robot.vy
          let new_y = case new_y < 0, new_y >= max_height {
            True, False -> new_y + max_height
            False, True -> new_y - max_height
            False, False -> new_y
            _, _ -> panic
          }
          Robot(new_x, new_y, robot.vx, robot.vy)
        })

      new_state
    })

  updated_robots
  |> list.fold(quadrents, fn(acc, robot) {
    acc
    |> list.map(fn(quadrent: #(#(Int, Int), #(Int, Int), List(Robot))) {
      let #(pos1, pos2, robots) = quadrent
      let #(x1, x2) = pos1
      let #(y1, y2) = pos2

      case robot.x >= x1 && robot.x <= x2 && robot.y >= y1 && robot.y <= y2 {
        True -> #(#(x1, x2), #(y1, y2), robots |> list.append([robot]))
        False -> {
          quadrent
        }
      }
    })
  })
  |> list.fold(1, fn(acc, quadrent) { acc * { quadrent.2 |> list.length() } })
}

pub fn pt_2(input: String) {
  let robots =
    input
    |> string.split("\n")
    |> list.map(fn(row) {
      let assert Ok(re) =
        regexp.from_string("p=(-?\\d*),(-?\\d*) v=(-?\\d*),(-?\\d*)")
      case regexp.scan(with: re, content: row) |> list.first() {
        Ok(data) -> {
          let assert [x, y, vx, vy] = data.submatches
          Robot(
            x |> safe_option_int,
            y |> safe_option_int,
            vx |> safe_option_int,
            vy |> safe_option_int,
          )
        }
        Error(_) -> panic
      }
    })

  let max_width = 101
  let max_height = 103

  let lower_half_max_width = max_width / 2 - 1
  let higher_half_max_width = max_width - max_width / 2
  let lower_half_max_height = max_height / 2 - 1
  let higher_half_max_height = max_height - max_height / 2
  let quadrents = [
    #(#(0, lower_half_max_width), #(0, lower_half_max_height), []),
    #(#(higher_half_max_width, max_width - 1), #(0, lower_half_max_height), []),
    #(#(0, lower_half_max_width), #(higher_half_max_height, max_height - 1), []),
    #(
      #(higher_half_max_width, max_width - 1),
      #(higher_half_max_height, max_height - 1),
      [],
    ),
  ]
  let updated_robots =
    list.range(1, 6243)
    // chinese remainder theorem solution: 82 mod 101  63 mod 103
    |> list.fold(robots, fn(state, idx) {
      let new_state =
        state
        |> list.map(fn(robot) {
          let new_x = robot.x + robot.vx
          let new_x = case new_x < 0, new_x >= max_width {
            True, False -> new_x + max_width
            False, True -> new_x - max_width
            False, False -> new_x
            _, _ -> panic
          }
          let new_y = robot.y + robot.vy
          let new_y = case new_y < 0, new_y >= max_height {
            True, False -> new_y + max_height
            False, True -> new_y - max_height
            False, False -> new_y
            _, _ -> panic
          }
          Robot(new_x, new_y, robot.vx, robot.vy)
        })

      new_state
    })

  list.range(1, max_height)
  |> list.index_map(fn(_, y) {
    list.range(1, max_width)
    |> list.index_map(fn(_, x) {
      let robot =
        updated_robots
        |> list.filter(fn(robot) { robot.x == x && robot.y == y })
      case robot |> list.length() {
        0 -> "."
        _ -> robot |> list.length() |> int.to_string()
      }
    })
    |> string.join("")
    |> io.println
  })
  6243
}
