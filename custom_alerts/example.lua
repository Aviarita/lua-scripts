local alerts = require("custom alerts")
local alert = alerts.create_alert("<font color='#96C83C'><b>gamesense.pub</b></font>")
alert.show()
client.delay_call(5, alert.hide)
