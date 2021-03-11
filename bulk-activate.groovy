#!/usr/bin/env groovy

if(args.length < 3){
	println 'Usage: bulk-activate.groovy [HOST] [USERNAME:PASSWORD] [SOURCE_FILE]'
}

println "Reading activation paths from ${args[2]}"
def source = new File(args[2])
def lines = source.readLines()

println "Activating pages on host ${args[0]}"

lines.each { String path ->
    println "Activating: ${path}"
	HttpURLConnection con = (HttpURLConnection) new URL("${args[0]}/bin/replicate.json?cmd=activate&path=${path}").openConnection()
    con.setRequestProperty ("Authorization", "Basic " + new String(Base64.getEncoder().encode(args[1].getBytes())))
    con.setRequestMethod("POST")
    con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded")
    con.setUseCaches(false)
    con.setDoInput(true)
    con.setDoOutput(true)
    con.setRequestProperty('User-Agent', 'curl/7.35.0')
    
    def rc = con.getResponseCode()
    if (rc == 200 || rc == 201) {
        println "Successfully activated ${path}"
        println "Response: ${con.getInputStream().getText()}"
    } else {
        throw new Exception("Retrieved failure code ${rc}")
    }
    
    con.disconnect()
}