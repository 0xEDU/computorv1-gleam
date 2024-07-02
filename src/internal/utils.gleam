import gleam/string
import gleam/list
    
fn do_to_string(acc: String, str_list: List(String)) {
    case str_list {
        [element, ..] -> string.append(acc, element) |> do_to_string(list.drop(str_list, 1))
        [] -> acc
    }
}
    
fn to_string(str_list: List(String)) -> String {
    do_to_string("", str_list)
}

pub fn strip_whitespaces(str: String) -> String {
    string.to_graphemes(str)
    |> list.filter(fn (c) { c != " "})
    |> to_string
}