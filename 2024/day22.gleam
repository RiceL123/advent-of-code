import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let part1 =
    get_initial_secrets("day22.txt")
    |> list.map(fn(x) { secret(x, 2000) })
    |> list.fold(0, fn(acc, x) { acc + x })

  io.debug(part1)
}

fn get_initial_secrets(file_path: String) -> List(Int) {
  case simplifile.read(file_path) {
    Ok(contents) ->
      contents
      |> string.split("\n")
      |> list.map(fn(line) {
        int.parse(line)
        |> result.unwrap(0)
      })
    Error(_) -> []
  }
}

fn secret(secret: Int, n: Int) -> Int {
  list.fold(list.range(1, n), secret, fn(acc, x) {
    let step1 =
      acc
      |> int.bitwise_exclusive_or(acc * 64)
      |> int.modulo(16_777_216)
      |> result.unwrap(0)

    let step2 =
      step1
      |> int.divide(32)
      |> result.unwrap(0)
      |> int.bitwise_exclusive_or(step1)
      |> int.modulo(16_777_216)
      |> result.unwrap(0)

    let step3 =
      step2
      |> int.bitwise_exclusive_or(step2 * 2048)
      |> int.modulo(16_777_216)
      |> result.unwrap(0)

    step3
  })
}
