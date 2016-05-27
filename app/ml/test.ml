let on_device_ready () =
  let s = Cordova_sms.t () in
  let dialog = Cordova_dialogs.t () in

  let num_node = Jsoo_lib.get_input_by_id "num" in
  let msg_node = Jsoo_lib.get_input_by_id "msg" in
  let btn_node = Jsoo_lib.get_button_by_id "submit" in

  let succ () =
    dialog#alert "Message sent!" ~title:"It's working!" ();
    num_node##.value := (Js.string "");
    msg_node##.value := (Js.string "")
  in
  let err msg =
    dialog#alert msg ~title:"Something wrong =(:" ()
  in

  btn_node##.onclick := Dom.handler
  (
    fun e ->
      let num = Js.to_string (num_node##.value) in
      let msg = Js.to_string (msg_node##.value) in
      if num = "" then
        dialog#alert "Please enter a phone number." ~title:"Missing field" ()
      else if msg = "" then
        dialog#alert "Please enter a message." ~title:"Missing field" ()
      else
        s#send ~num:num ~msg:msg ~succ_cb:succ ~err_cb:err ();
      Js._false
  )

  (*
  ignore
  (
    Lwt_js_events.clicks btn_node
    (
      fun ev thread ->
        let num = Js.to_string (num_node##.value) in
        let msg = Js.to_string (msg_node##.value) in
        if num = "" then
          dialog#alert "Please enter a phone number." ~title:"Missing field" ()
        else if msg = "" then
          dialog#alert "Please enter a message." ~title:"Missing field" ()
        else
          s#send ~num:num  ~msg:msg ~succ_cb:succ ~err_cb:err ();
        Lwt.return ()
    );
  );
  *)

let _ = Cordova.Event.device_ready on_device_ready
