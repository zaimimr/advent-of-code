import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn pt_1(input: String) {
  let data =
    input
    |> string.split("\n")
    |> list.map(fn(item) {
      item
      |> string.split_once("   ")
      |> result.unwrap(#("", ""))
    })
    |> list.unzip

  let #(list1, list2) = data
  let sorted_list1 = list.sort(list1, string.compare)
  let sorted_list2 = list.sort(list2, string.compare)

  list.zip(sorted_list1, sorted_list2)
  |> list.map(fn(items) {
    let #(item1, item2) = items
    let #(intitem1, intiten2) = #(
      int.parse(item1) |> result.unwrap(0),
      int.parse(item2) |> result.unwrap(0),
    )

    intitem1 - intiten2
    |> int.absolute_value
  })
  |> list.fold(0, int.add)
}

pub fn pt_2(input: String) {
  let data =
    input
    |> string.split("\n")
    |> list.map(fn(item) {
      item
      |> string.split_once("   ")
      |> result.unwrap(#("", ""))
    })
    |> list.unzip
  let #(list1, list2) = data

  let map2 =
    list2
    |> list.fold(dict.new(), fn(acc, item) {
      dict.upsert(acc, item, fn(x) {
        case x {
          option.Some(i) -> i + 1
          option.None -> 1
        }
      })
    })

  list1
  |> list.fold(0, fn(acc, item) {
    let dict_value = dict.get(map2, item) |> result.unwrap(0)
    acc + result.unwrap(int.parse(item), 0) * dict_value
  })
}
