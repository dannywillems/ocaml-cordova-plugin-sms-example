let doc = Dom_html.document

let dialog = Cordova_dialogs.t ()

(*
let text_field =
  let row = Dom_html.createDiv doc in
  let col_s12 = Dom_html.createDiv doc in
  let row_text = Dom_html.createDiv doc in
  let col_inp_field_num = Dom_html.createDiv doc in
  let input_num = Dom_html.createInput doc in
  let label_num = Dom_html.createLabel doc in
  let col_inp_field_text = Dom_html.createDiv doc in
  let input_text = Dom_html.createDiv doc in
  let label_text = Dom_html.createLabel doc in

  row##.className := (Js.string "row");
  col_s12##.className := (Js.string "col s12");
  row_text##.className := (Js.string "row");
  col_inp_field_num##.className := (Js.string "input-field col s6");
  input_num##.id := (Js.string "num");
  input_num##.className := (Js.string "validate");

  Dom.appendChild col_inp_field_text input_text;
  Dom.appendChild col_inp_field_num input_num;
  Dom.appendChild row_text col_inp_field_num;
  Dom.appendChild row_text col_inp_field_num;
  Dom.appendChild col_s12 row_text;
  Dom.appendChild row col_s12;
  row
*)

let succ_cb () =
  dialog#alert "Message sent!" ()

let err_cb err =
  dialog#alert err ()

let on_device_ready _ =
  let s = Cordova_sms.t () in
  let num_node = Jsoo_lib.get_input_by_id "num" in
  let msg_node = Jsoo_lib.get_input_by_id "msg" in
  let btn_node = Jsoo_lib.get_button_by_id "submit" in

  Lwt.async
  (
    fun () -> Lwt_js_events.clicks btn_node
    (
      fun ev thread ->
        let num = Js.to_string (num_node##.value) in
        let msg = Js.to_string (msg_node##.value) in

        Jsoo_lib.console_log num;
        Jsoo_lib.console_log msg;
        s#send ~num:num  ~msg:msg ~succ_cb:succ_cb ~err_cb:err_cb ();
        Lwt.return ()
    )
  );
  Js._false

let _ =
  Dom.addEventListener Dom_html.document (Dom.Event.make "deviceready")
(Dom_html.handler on_device_ready) Js._false
