import gleam/float
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import utils

pub fn parse_input(input: String) {
  input
  |> string.split("\n\n")
  |> list.map(fn(x) {
    x
    |> string.split("\n")
    |> list.map(fn(y) {
      y
      |> string.split_once(": ")
      |> result.unwrap(#("", ""))
      |> pair.second()
      |> string.split_once(", ")
      |> result.unwrap(#("", ""))
      |> pair.map_first(fn(nr) {
        nr
        |> string.replace("X", "")
        |> string.replace("+", "")
        |> string.replace("=", "")
        |> utils.safe_int()
      })
      |> pair.map_second(fn(nr) {
        nr
        |> string.replace("Y", "")
        |> string.replace("+", "")
        |> string.replace("=", "")
        |> utils.safe_int()
      })
    })
  })
}

pub fn pt_1(input: String) {
  parse_input(input)
  |> list.map(fn(x) {
    let assert [a, b, price] = x

    let eq = #(#(a.0, b.0, price.0), #(a.1, b.1, price.1))

    let d = { eq.0.0 * eq.1.1 - eq.0.1 * eq.1.0 } |> int.to_float()
    let dx = { eq.0.2 * eq.1.1 - eq.0.1 * eq.1.2 } |> int.to_float()
    let dy = { eq.0.0 * eq.1.2 - eq.0.2 * eq.1.0 } |> int.to_float()
    let x = float.divide(dx, d) |> result.unwrap(0.0)
    let y = float.divide(dy, d) |> result.unwrap(0.0)
    case { x == float.floor(x) } && { y == float.floor(y) } {
      True -> #(float.round(x), float.round(y))
      False -> #(0, 0)
    }
  })
  |> list.filter(fn(x) { x.0 > 0 && x.1 > 0 })
  |> list.map(fn(x) { x.0 * 3 + x.1 })
  |> list.reduce(int.add)
}

pub fn pt_2(input: String) {
  parse_input(input)
  |> list.map(fn(x) {
    let assert [a, b, price] = x

    let eq = #(#(a.0, b.0, price.0 + 10_000_000_000_000), #(
      a.1,
      b.1,
      price.1 + 10_000_000_000_000,
    ))

    let d = { eq.0.0 * eq.1.1 - eq.0.1 * eq.1.0 } |> int.to_float()
    let dx = { eq.0.2 * eq.1.1 - eq.0.1 * eq.1.2 } |> int.to_float()
    let dy = { eq.0.0 * eq.1.2 - eq.0.2 * eq.1.0 } |> int.to_float()
    let x = float.divide(dx, d) |> result.unwrap(0.0)
    let y = float.divide(dy, d) |> result.unwrap(0.0)
    case { x == float.floor(x) } && { y == float.floor(y) } {
      True -> #(float.round(x), float.round(y))
      False -> #(0, 0)
    }
  })
  |> list.filter(fn(x) { x.0 > 0 && x.1 > 0 })
  |> list.map(fn(x) { x.0 * 3 + x.1 })
  |> list.reduce(int.add)
}
