
open Mlpost
open Num
open Box
open Command

let caml = [|
"..**..........";
".***..........";
"****..**.**...";
"..**..*****...";
"..**.*******..";
"..***********.";
"..************";
"...****..***.*";
"....**....**..";
"....**....**..";
"....**....**..";
"....**....**..";
"....**....**..";
           |]

let caml2 = [|
"....****....................";
"..******....................";
"********....****..****......";
"....****....**********......";
"....****..**************....";
"....**********************..";
"....************************";
"......********....******..**";
"........****........****....";
"........****........****....";
"........****........****....";
"........****........****....";
"........****........****....";
            |]

let bool_array_of_string s = Array.init (String.length s) (fun i -> s.[i] = '*')
let caml = Array.map bool_array_of_string caml
let caml2 = Array.map bool_array_of_string caml2

let u = bp 5.
let p x y = Point.pt (x *. u, -. y *. u)
let cell =
  Box.shift (p 0.5 0.5) (rect ~dx:zero ~dy:zero (empty ~width:u ~height:u ()))

let of_bool_matrix m =
  let h = Array.length m in
  assert (h > 0);
  let w = Array.length m.(0) in
  iter 0 (h-1) (fun y ->
  iter 0 (w-1) (fun x ->
    if m.(y).(x) then Box.draw (Box.shift (p (float x) (float y)) cell)
    else nop))

let () = Metapost.emit "caml_problem" (of_bool_matrix caml)
let () = Metapost.emit "caml2_problem" (of_bool_matrix caml2)

let caml_solution = [|
"..TT..........";
".UUS..........";
"VVRS..44.10...";
"..RQ..53210...";
"..PQ.=532966..";
"..PMM=><;9:87.";
"..OOLL><;?:87W";
"...NNDD..?A@.W";
"....EE....A@..";
"....GF....CB..";
"....GF....CB..";
"....KJ....IH..";
"....KJ....IH..";
                    |]

let char_array_of_string s = Array.init (String.length s) (fun i -> s.[i])
let caml_solution = Array.map char_array_of_string caml_solution

let hdomino =
  Box.shift (p 1. 0.5)
    (round_rect ~dx:zero ~dy:zero (empty ~width:(2.*.u) ~height:u ()))
let vdomino =
  Box.shift (p 0.5 1.)
    (round_rect ~dx:zero ~dy:zero (empty ~width:u ~height:(2.*.u) ()))

let of_char_matrix m =
  let seen = Hashtbl.create 17 in Hashtbl.add seen '.' ();
  let unseen c = not (Hashtbl.mem seen c || (Hashtbl.add seen c (); false)) in
  let h = Array.length m in
  assert (h > 0);
  let w = Array.length m.(0) in
  iter 0 (h-1) (fun y ->
  iter 0 (w-1) (fun x ->
    let c = m.(y).(x) in
    if unseen c then begin
      if x < w-1 && m.(y).(x+1) = c then
        Box.draw (Box.shift (p (float x) (float y)) hdomino)
      else
        Box.draw (Box.shift (p (float x) (float y)) vdomino)
    end else nop))

let () = Metapost.emit "caml_solution" (of_char_matrix caml_solution)

let modbox s =
  round_rect (tex (Format.sprintf "\\tt %s" s))

let archi =
  let tiling = modbox "Tiling" in
  let emc = modbox "Emc" in
  let zdd = modbox "Zdd" in
  let dlx = modbox "Dlx" in
  let b = vbox ~padding:(bp 30.)
    [tiling;
     emc;
     hbox ~padding:(bp 30.) [dlx; zdd]]
  in
  let box_label_arrow x y ~pos ~label =
    let label = Picture.tex label in
    Helpers.box_label_arrow ~sep:(bp 5.) ~pos label (sub x b) (sub y b) in
  Box.draw b ++
  box_label_arrow tiling emc ~label:"r\\'eduction" ~pos:`Right ++
  box_label_arrow emc    dlx ~label:"imm\\'ediat"  ~pos:`Left  ++
  box_label_arrow emc    zdd ~label:"r\\'eduction" ~pos:`Right ++
  nop

let () = Metapost.emit "archi" archi