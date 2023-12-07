module HTMLParser = struct
  open Soup

  let to_string input =
    let soup = parse input in
    texts soup |> String.concat ""
end

module Lexer = struct
  type token =
    | Word of string
    | Number of string
    | Other of char
  ;;

  let is_alpha char = match char with
    | 'a'..'z' | 'A'..'Z' -> true
    | _ -> false
  ;;

  let is_digit char = match char with
    | '1'..'9' -> true
    | _ -> false
  ;;

  let skip_char char =
    match char with
    | ' ' | '\n' -> true
    | _ -> false

  let chars_to_string chars =
    chars |> List.to_seq |> String.of_seq

  let drop_while pred chars =
    let acc_to_string acc =
      acc |> List.rev |> chars_to_string
    in
    
    let rec drop_while pred chars acc =
      match chars with
      | [] -> acc_to_string acc, []
      | ' ' :: tail -> acc_to_string acc, tail
      | head :: tail when pred head ->
        let acc = head :: acc in 
        drop_while pred tail acc
      | input -> acc_to_string acc, input
    in
    drop_while pred chars []
  
  let rec tokenize (input : char list) acc =
    match input with
    | [] -> acc
    | head :: tail when skip_char head -> tokenize tail acc
    | head :: _ when is_alpha head -> 
      let word, rest = drop_while is_alpha input in 
      tokenize rest (Word word :: acc)
    | head :: _ when is_digit head ->
      let word, rest = drop_while is_digit input in 
      tokenize rest (Number word :: acc)
    | head :: tail ->
      let token = Other head in
      tokenize tail (token :: acc)
end

let () = print_endline "Hello, World!"
