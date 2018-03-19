var socket = new Phoenix.Socket("/socket", {})
socket.connect()

var channel = socket.channel("rates", {})

channel.on("crypto_rates", msg => {
  console.log("Got message", msg)
  var old_tbody = document.getElementById("tbody")
  var new_tbody = document.createElement("tbody");
  new_tbody.id = "tbody"

  new_tbody.innerHTML = msg.rates.reduce((acc, rate) => render_row(rate) + acc, '')

  old_tbody.parentNode.replaceChild(new_tbody, old_tbody)
})

channel.join()
  .receive("ok", (res) => console.log("catching up", res) )
  .receive("error", (res) => console.log("failed join", res) )
  .receive("timeout", () => console.log("Networking issue. Still waiting...") )

var render_row = (rate) => (
  "<tr>" +
    "<td scope='row'>" + rate.from + "-" + rate.to + "</td>" +
    "<td>" + rate.rate + "</td>" +
    "<td>" + rate.at + "</td>" +
  "</tr>"
)
