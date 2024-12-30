import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Operation {
  Add
  Multiply
  Concat
}

pub fn parse_input(input: String) {
  input
  |> string.split("\n")
  |> list.filter(fn(line) { line != "" })
  |> list.map(fn(line) {
    let #(ans, eq) = line |> string.split_once(":") |> result.unwrap(#("", ""))
    let target = ans |> int.parse() |> result.unwrap(0)

    let numbers =
      eq
      |> string.trim()
      |> string.split(" ")
      |> list.filter(fn(x) { x != "" })
      |> list.index_map(fn(num, i) {
        #(i, num |> int.parse() |> result.unwrap(0))
      })

    let eq_len = list.length(numbers)
    let numbers = numbers |> dict.from_list()
    #(target, numbers, eq_len)
  })
}

pub fn generate_operations(length, base) {
  let max =
    int.power(base, length - 1 |> int.to_float)
    |> result.unwrap(0.0)
    |> float.round()
  list.range(0, max - 1)
  |> list.map(fn(n) {
    list.range(0, length - 2)
    |> list.map(fn(i) {
      let power =
        int.power(base, i |> int.to_float())
        |> result.unwrap(0.0)
        |> float.round()
      let digit =
        int.divide(n, power)
        |> result.unwrap(0)
        |> int.modulo(base)
        |> result.unwrap(0)
      case digit {
        0 -> Add
        1 -> Multiply
        2 -> Concat
        _ -> panic
      }
    })
  })
}

fn evaluate(numbers, operations) {
  operations
  |> list.index_fold(numbers |> dict.get(0) |> result.unwrap(0), fn(acc, op, i) {
    let next = numbers |> dict.get(i + 1) |> result.unwrap(0)
    case op {
      Add -> acc + next
      Multiply -> acc * next
      Concat ->
        string.append(acc |> int.to_string(), next |> int.to_string())
        |> int.parse()
        |> result.unwrap(0)
    }
  })
}

pub fn pt(input: String, base: Int) {
  parse_input(input)
  |> list.map(fn(data) {
    let #(target, numbers, eq_len) = data
    let possible_operations = generate_operations(eq_len, base)

    possible_operations
    |> list.find(fn(operations) { evaluate(numbers, operations) == target })
    |> result.map(fn(_) { target })
    |> result.unwrap(0)
  })
  |> list.fold(0, fn(acc, x) { acc + x })
}

pub fn pt_1(input: String) {
  pt(input, 2)
}

pub fn pt_2(input: String) {
  pt(input, 3)
}
