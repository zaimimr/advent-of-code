import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub fn safe_int(input: String) -> Int {
  int.parse(input) |> result.unwrap(0)
}

pub fn string_list_from_string(
  input: String,
  split: String,
) -> List(List(String)) {
  input
  |> string.split("\n")
  |> list.map(fn(item) {
    item
    |> string.split(split)
  })
}

pub fn int_list_from_string(input: String, split: String) -> List(List(Int)) {
  string_list_from_string(input, split)
  |> list.map(fn(item) {
    item
    |> list.filter_map(int.parse)
  })
}

pub type Tree(a) {
  Leaf
  Node(value: a, left: Tree(a), right: Tree(a))
}

pub opaque type Zipper(a) {
  Zipper(focus: Tree(a), trail: List(Branch(a)))
}

type Branch(a) {
  Branch(direction: Direction, value: a, alternative: Tree(a))
}

type Direction {
  Left
  Right
}

pub fn to_zipper(tree: Tree(a)) -> Zipper(a) {
  Zipper(focus: tree, trail: [])
}

pub fn to_tree(zipper: Zipper(a)) -> Tree(a) {
  case up(zipper) {
    Ok(zipper) -> to_tree(zipper)
    Error(Nil) -> zipper.focus
  }
}

pub fn value(zipper: Zipper(a)) -> Result(a, Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(value: value, ..) -> Ok(value)
  }
}

pub fn up(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.trail {
    [] -> Error(Nil)

    [Branch(Left, value, alternative), ..rest] ->
      Ok(Zipper(
        focus: Node(value, left: zipper.focus, right: alternative),
        trail: rest,
      ))

    [Branch(Right, value, alternative), ..rest] ->
      Ok(Zipper(
        focus: Node(value, left: alternative, right: zipper.focus),
        trail: rest,
      ))
  }
}

pub fn left(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)

    Node(value, left, right) ->
      Ok(
        Zipper(focus: left, trail: [
          Branch(Left, value, alternative: right),
          ..zipper.trail
        ]),
      )
  }
}

pub fn right(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)

    Node(value, left, right) ->
      Ok(
        Zipper(focus: right, trail: [
          Branch(Right, value, alternative: left),
          ..zipper.trail
        ]),
      )
  }
}

pub fn set_value(zipper: Zipper(a), value: a) -> Zipper(a) {
  case zipper.focus {
    Leaf -> Zipper(..zipper, focus: Node(value, Leaf, Leaf))
    Node(_, left, right) -> Zipper(..zipper, focus: Node(value, left, right))
  }
}

pub fn set_left(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(value, _, right) ->
      Ok(Zipper(..zipper, focus: Node(value, tree, right)))
  }
}

pub fn set_right(zipper: Zipper(a), tree: Tree(a)) -> Result(Zipper(a), Nil) {
  case zipper.focus {
    Leaf -> Error(Nil)
    Node(value, left, _) -> Ok(Zipper(..zipper, focus: Node(value, left, tree)))
  }
}
