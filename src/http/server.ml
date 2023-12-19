open Piaf

let handle_health_check () =
  Logs.info (fun m -> m "server.handle_health_check");
  let body = "Status: Health" in
  Response.of_string ~body `OK

let handle_not_found () = 
  Logs.info (fun m -> m "server.handle_not_found");
  Response.of_string ~body:"not found" `Not_found

let handle_index _deps uri =
  Logs.info (fun m -> m "server.handle_index(uri=%s)" uri);
  let body = Printf.sprintf "indexing %s..." uri in
  Response.of_string ~body `OK

let request_handler deps (params : Request_info.t Server.ctx) =
  let meth = params.request.meth in
  let path = 
      params.request
    |> Request.uri
    |> Uri.path in


  Logs.info (fun m ->
    let meth = Method.to_string meth in
    m "Request %s: %s" meth path);

  let path =
    path
    |> String.split_on_char '/'
    |> List.filter (fun x -> String.length x > 0) in


  match meth, path with
  | `GET, [] | `GET, [""] -> handle_health_check ()
  | `GET, "index" :: url :: [] -> handle_index deps url
  | _ -> handle_not_found ()

let host_to_str host = Fmt.str "%a" Eio.Net.Ipaddr.pp host

let run ~sw ~host ~port ~env deps =
  let config =
    Server.Config.create (`Tcp (host, port))
  in
  let handler = request_handler deps in
  let server = Server.create ~config handler in
  print_endline @@ Printf.sprintf "listening on http://%s:%d/" (host_to_str host) port;
  let () = Eio.Net.Ipaddr.pp Format.str_formatter host in
  let command = Server.Command.start ~sw env server in
  command

let listen ~sw ~env ~deps =
  let host = Eio.Net.Ipaddr.V4.loopback in
  run ~sw ~host ~port:8080 ~env deps
