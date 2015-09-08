require 'erb'
require 'csv'

shipments = []

CSV.foreach("./planet_express_logs.csv", headers: true) {|line|
  shipments.push(line.to_hash)

}



# 1. open the file and store contain in a varible.
html_string = File.read("./template.html.erb")
print html_string

#Put a value into html_string






amount = shipments.map {|cash| cash["Money"].to_i}.reduce(:+)


deliverer_log = [
  {"Name" => "Fry"   , "# Of Trips" =>  0 ,  "Total_bonus" =>  0},
  {"Name" =>  "Amy"  , "# Of Trips"  => 0 , "Total_bonus"  =>  0},
  {"Name" => "Bender" ,  "# Of Trips" => 0,  "Total_bonus"  => 0},
  {"Name" => "Leela" ,   "# Of Trips" => 0,  "Total_bonus"  => 0}
]

shipments.each { |shpmnt|

# 1) Determine Deliverer based on shipment's Destination

if shpmnt["Destination"] == "Earth" #->earth
  pilot_name = "Fry"
elsif shpmnt["Destination"] == "Mars" #->earth
  pilot_name = "Amy"
elsif shpmnt["Destination"] == "Uranus" #->earth
  pilot_name = "Bender"
else
  pilot_name = "Leela"
end

filtered_pilot = deliverer_log.select {|pilot| pilot["Name"] == pilot_name}
the_pilot = filtered_pilot.first


# 2) Calulate shipment's bonus due to Deliverer
    bonus = shpmnt["Money"].to_i * 0.10
    the_pilot["Total_bonus"] = the_pilot["Total_bonus"] + bonus

# 3) Add one to the Deliverer's # of "trips"
    the_pilot["# Of Trips"] = the_pilot["# Of Trips"] + 1

}

puts deliverer_log





compiled_html = ERB.new(html_string).result(binding)
print compiled_html

#3. Write the new file with our values from here
File.open("./index-output.html", "wb") {|new_f|
    new_f.write(compiled_html)
    new_f.close()
}
