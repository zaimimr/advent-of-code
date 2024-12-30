import gleam/list
import gleam/option
import gleam/regexp
import utils

fn multiply_submatches(submatches: List(option.Option(String))) -> Int {
  submatches
  |> list.fold(1, fn(acc, submatch) {
    let item = option.then(submatch, fn(x) { option.Some(utils.safe_int(x)) })
    acc * option.unwrap(item, 1)
  })
}

pub fn pt_1(input: String) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d*),(\\d*)\\)")
  re
  |> regexp.scan(input)
  |> list.fold(0, fn(acc, match) { acc + multiply_submatches(match.submatches) })
}

pub fn pt_2(input: String) {
  let assert Ok(re) =
    regexp.from_string("mul\\((\\d*),(\\d*)\\)|(do|don\\'t)\\(\\)")
  let data =
    re
    |> regexp.scan(input)
    |> list.fold(#(0, True), fn(acc, match) {
      case match.content, acc.1 {
        "do()", _ -> #(acc.0, True)
        "don't()", _ -> #(acc.0, False)
        _, True -> #(acc.0 + multiply_submatches(match.submatches), True)
        _, False -> acc
      }
    })
  data.0
}
