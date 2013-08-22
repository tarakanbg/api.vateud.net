# VATEUD API Documentation
#### _by **Svilen Vassilev**, VATEUD7_

## Features

* The API supports __json__, __xml__ and __csv__ for its data. Use whatever you prefer.
* It requires no authentication, no API keys, just send a plain GET request and you're served.
* Be reasonable when polling for changes: the data is only updated once a day anyway.
* These API calls are served by our EUD server, hence they impose no load or access concerns on the
    upstream VATSIM databases.
* Action caching is used, all responses are cached, expiration time is 3 hours.
* Authenticated endpoint for vACCs to obtain the emails of their own members (see below)
* Public endpoints for obtaining online stations data (pilots, ATCOs) and scoping it by airport(s)/FIR(s)
* Public endpoints for obtaining an always current list of RW NOTAMs scoped by airport(s)/FIR(s)
* Public endpoints for obtaining an always current list of airport charts
* HTML interface for all public endpoints

The subset of data available includes:

### For the members data:


* `Vatsim ID`
* `First and last name`
* `ATC Rating`
* `Pilot Rating`
* `Humanized ATC Rating`
* `Humanized Pilot Rating`
* `Country`
* `Registration date`
* `Subdivision (vACC)`
* `Email:` by using the authenticated vACC specific endpoint (see below)
* `Suspension end date` (if any): by using the authenticated vACC specific endpoint (see below)

_Note:_ The first/last names are preemptively capitalized "on the fly" for you; many aren't in the VATSIM
database. Also I'm humanizing the ATC and pilot ratings so you don't have to :) The original integer values
for both ratings are kept in the data for compatibility, should you need them.

### For the online stations data:

* `cid` (VATSIM ID)
* `callsign`
* `name`
* `role`
* `frequency`
* `altitude`
* `planned_altitude` (or FL)
* `heading`
* `groundspeed`
* `transponder`
* `aircraft`
* `origin`
* `destination`
* `route`
* `rating` (returns a humanized version of the VATSIM rating: S1, S2, S3, C1, etc...)
* `facility`
* `remarks`
* `atis` (raw atis, as reported from VATSIM, including voice server as first line)
* `atis_message` (a humanized version of the ATC atis w/o server and with lines split)
* `logon` (login time as unparsed time string: 20120722091954)
* `online_since` (returns the station login time parsed as a Ruby Time object in UTC)
* `latitude`
* `longitude`
* `latitude_humanized` (e.g. N44.09780)
* `longitude_humanized` (e.g. W58.41483)
* `qnh_in` (indicated QNH in inches Hg)
* `qnh_mb` (indicated QNH in milibars/hectopascals)
* `flight_type` (I for IFR, V for VFR, etc)
* `gcmap` (returns a great circle map image url)

__You can either request all EUD members or scope them through a subdivision (vACC) or country or rating.__
All records are sorted in reverse chronological order for conveneince (newest on top), but granted you have the
reg date in the data you can parse them any way you want.

__Here's how it works:__

You have basic url to poll with a GET request and you __must append either a json, xml or csv extension__
to the end of the url to get the relevant format. For all public endpoints omitting the format extension
will return an html response: part of the web interface of the API.

All URL's use the __api.vateud.net__ subdomain, the older vaccs.vateud.net one is kept indefinitely
for compatibility and CNAME-d to the main one.

### A. Pulling all records

    http://api.vateud.net/members.json   #=> returns all EUD members in JSON format  
    http://api.vateud.net/members.xml    #=> returns all EUD members in XML format  
    http://api.vateud.net/members.csv    #=> returns all EUD members in CSV format  

### B. Scoping through vACC

    http://api.vateud.net/members/BULG.json   #=> returns all members of the Bulgarian vACC in JSON format  
    http://api.vateud.net/members/BHZ.xml     #=> returns all members of the Bosnia-Herzegovina vACC in XML format  
    http://api.vateud.net/members/GRE.csv     #=> returns all members of the Greece vACC in CSV format  

As you can see, scoping through vACC is a matter of __adding the vACC code designator to the request URL__.
You can check [all vacc codes here](http://api.vateud.net/subdivisions).

The vACC codes inside the URL are NOT case sensitive, so you can as well use:

    http://api.vateud.net/members/aust.json   #=> returns all members of the Austrian vACC in JSON format  
    http://api.vateud.net/members/yug.xml     #=> returns all members of the Serbian vACC in XML format  
    http://api.vateud.net/members/fra.csv     #=> returns all members of the France vACC in CSV format  

### C. Scoping through country

The vast majority of users do not belong to a subdivision (vACC). Each user though belongs to a country
(it's mandatory to select one during initial registration on VATSIM). I thought it might be a useful metrics
to provide member listings by country, thus vACC staff should be able to see all VATSIM member from their
country and which vACC they belong to (if any).

The base URL you need to poll for this is: _vaccs.vateud.net/countries/_ and add the country code and format
extension:

    http://api.vateud.net/countries/BG.json   #=> returns all members from Bulgaria in JSON format  
    http://api.vateud.net/countries/CH.xml    #=> returns all members from Switzerland in XML format  
    http://api.vateud.net/countries/BE.csv    #=> returns all members from Belgium in CSV format  

You can see all available country codes at [api.vateud.net/countries](http://api.vateud.net/countries)

### D. Scoping through rating

You can also scope the members through rating.

The base URL you need to poll for this is: _api.vateud.net/ratings/_ and add the rating code and format extension:

    http://api.vateud.net/ratings/7.json     #=> returns all C3 (Senior Controller) members in JSON format  
    http://api.vateud.net/ratings/8.xml      #=> returns all INS (Instructor) members in XML format  
    http://api.vateud.net/ratings/2.csv      #=> returns all S1 (Student) members in CSV format  

You can see all available rating codes at [api.vateud.net/ratings](http://api.vateud.net/ratings/)

### E. Authenticated endpoint for vACC email listings

__Features:__

* vACCs are able to obtain member listings including their members' emails by using an authenticated endpoint utilizing unique access tokens
* Accessing this endpoint without an access token will result in a 401 error
* Access tokens are associated with a particular vACC and are only good for that vACC: they can't be used to access the member listings of other vACCs or any other scope of members (error message will be returned). I.e. an access token issued to vACCBUL is only good for fetching vACCBUL members, can't be used for fetching let's say VATITA or vACC Austria members or any members that have selected Bulgaria as a country but do not belong to vACCBUL.
* Access tokens will be issued on vACC staff member request, preferably  coming from the vACC webmaster or director. You can request an access token for your vACC by creating a task, assigned to me (or the current VATEUD7) here:
[tasks.vateud.net](http://tasks.vateud.net/)
* VATEUD reserves the right to revoke an access token and/or replace it if leaks or abuse is detected.

__How it works:__

The endpoint for this is of the type __"api.vateud.net/emails/" + vACC code + desired format extension__. 
The access token should be passed  __as a header__ together with the GET request in the following syntax:
_'Authorization: Token token="your-vacc-access-token"'_.
I considered including the access token as part of the URL requests, but given the nefarious habit of Internet
users to share links left, right and center, decided against it, sorry.
You can use curl or any alternative that you fancy.

__Examples:__

    curl api.vateud.net/emails/bhz.json  -H 'Authorization: Token token="bhz-vacc-access-token"'  
          #=>  returns the members listing for Bosnia-Herzegovina vACC in json format 
    curl api.vateud.net/emails/bulg.xml  -H 'Authorization: Token token="bulg-vacc-access-token"'
          #=>  returns the members listing for Bulgaria vACC in xml format  
    curl api.vateud.net/emails/gre.csv  -H 'Authorization: Token token="gre-vacc-access-token"'
          #=>  returns the members listing for Greek vACC in csv format  
    curl api.vateud.net/emails/bhz.json  -H 'Authorization: Token token="non-existing-token"'
          #=>  returns 401 unauthorized error  
    curl api.vateud.net/emails/bhz.json  
          #=>  returns 401 unauthorized error  
    curl api.vateud.net/emails/bhz.json  -H 'Authorization: Token token="another-vacc-token"'
          #=> returns an eloquent error message  

Essentially the data you get via this endpoint is the same data you get via the "members" endpoint.
The only difference being that this one also includes the emails and suspension end dates.

___A note regarding pilot ratings:___ Pilot ratings are stored as a __bitmask__ in the VATSIM database,
and are included the same way in the raw data that we give you. They are additionally "humanized"
for convenience (look for the "humanized pilot rating" field). In order to understand what bitmask
is and how it works, read [this simple explanation](http://stu.mp/2004/06/a-quick-bitmask-howto-for-programmers.html).
Also you can [use Google as bitmask calculator](https://www.google.com/search?q=7+mod+4). Here are some example
bitmask representations of pilot rating combinations, based on the currently available pilot ratings:

    0  => "P0"  
    1  => "P1"  
    3  => "P1, P2"  
    4  => "P3"  
    5  => "P1, P3"  
    7  => "P1, P2, P3"  
    9  => "P1, P4"  
    11 =>  "P1, P2, P4"  
    15 =>  "P1, P2, P3, P4"  
    31 =>  "P1, P2, P3, P4, P5"  
      
    ....etc....  

### F. Online stations data

__This portion of the API is powered by the [vatsim_online](https://rubygems.org/gems/vatsim_online) library.
If you're curious to see in detail how it works and the full array of options it provides, head over
[to the documentation](https://github.com/tarakanbg/vatsim_online#vatsim-online).__


These are public endpoints of the type: "http://api.vateud.net/online/" + station type + ICAO filter + format
type extension

Available station types: atc, pilots, arrivals, departures.

The ICAO filter is a string of full or partial, one or multiple comma separated ICAO codes
(designating FIR(s) or airport(s)) that will be used to filter out the requested online data.
They are __not__ case sensitive. For example you can use the "ed" filter to show all stations 
in Germany, or "loww,lowi" filter to show all stations for Vienna and Innsbruck airports, or 
"low, ed" filter to show all stations for all Austrian and German airports, etc

Examples:

    http://api.vateud.net/online/atc/ed.json              #=> returns all German online ATC stations in JSON format  
    http://api.vateud.net/online/pilots/low.xml           #=> returns all online pilot stations, inbound or outbound
                                                              to one of Austria's major airports in XML format  
    http://api.vateud.net/online/arrivals/egll,egcc.csv   #=> returns all inbound flights to London Heathrow or 
                                                              Manchester airports in CSV format  
    http://api.vateud.net/online/departures/lp.xml        #=> returns all departures from Portuguese airports in
                                                              xml format  
      
    ....etc.....  

__Note:__ The online stations responses are all being cached with expiration time set to 5 minutes.
The online stations data is not limited to EUD, you can use it for any airport(s)/FIR(s) in the world.

### G. Current RW NOTAMs

__This portion of the API is powered by the [notams](http://rubygems.org/gems/notams) library.
If you're curious to see in detail how it works and the full array of options it provides, head over
[to the documentation](https://github.com/tarakanbg/notams).__

These are public endpoints of the type: "http://api.vateud.net/notams/" + ICAO filter + format
type extension

The ICAO filter is a string of one or multiple comma separated ICAO codes
(designating FIR(s) or airport(s)) that will be used to filter out the requested notams data.
They are __not__ case sensitive. For example you can use "lqsa,lqmo" to get all notams for
Sarajevo and Mostar airports or "lqsb" to get all notams related to Bosnia-Herzegovina FIR,
or "LQSA,LQMO,LQSB" to get a combined list of the 2 airports NOTAMs plus all FIR-wide NOTAMs.

The responses will return 3 attributes for each NOTAM:

* `ICAO` - the code of the airport or FIR the NOTAM applies to
* `raw` - the raw record of the notam, providing it's full unparsed contents
* `message` - just the essential informational part of the notam, with all the overhead stripped out

All NOTAMs responses are cached, the expiration time is currently set at 24 hours.

Examples:

    http://api.vateud.net/notams/lqsa.json              #=> returns all Sarajevo NOTAMs in JSON format  
    http://api.vateud.net/notams/LQSA,LQMO,LQSB.xml     #=> returns all NOTAMs for Sarajevo and Mostar
                                                            airports and BiH FIR in XML format
    http://api.vateud.net/notams/loww.csv               #=> returns all NOTAMs for Vienna Airport in CSV
    http://api.vateud.net/notams/lbsf                   #=> returns all NOTAMs for Sofia as HTML listing

### H. Airport Charts

These are public endpoints of the type: "http://api.vateud.net/charts/" + airport ICAO code + format
type extension

Omitting the format type extension will return an html response with a chart listing (part of the API [web
interface](http://api.vateud.net/charts))

The response will return 4 attributes for each chart:

* `ICAO` - the code of the airport the chart refers to
* `name` - the name of the chart
* `url_aip` - link to the official source of the chart
* `url_charts_aero` - link to the cached version of the chart at charts.aero

All chart responses are cached, the expiration time is currently set at 2 hours.

Examples:

    http://api.vateud.net/charts/lowi.json              #=> returns all Innsbruck charts in JSON format  
    http://api.vateud.net/charts/EGLC.xml               #=> returns all London City charts in XML format
    http://api.vateud.net/charts/lgav.csv               #=> returns all Athens airport charts in CSV
    http://api.vateud.net/charts/loww                   #=> returns an HTML listing of all Vienna charts

The chart listings are automatically synchronized with RW sources and are __always current__. Note, we only
provide links to the publications, not physical files. __Not to be used for real world navigation!__

### I. Member Validation

This endpoint is of the type: `http://api.vateud.net/members/validate/`. It receives a member cid
and email (sent along a GET request as headers) and matches them against
the DB. It returns `1` if a matching cid/email pair is found or otherwise returns `0`.

Useful for vACCs that run user registration checks on their websites to avoid bot registrations and (to 
a certain extent) impersonation.

Examples:
    
    # Curl command line:

    curl api.vateud.net/members/validate -H 'cid: 1175035' -H 'email: tarakan.sv@gmail.com'  #=> 1
    curl api.vateud.net/members/validate -H 'cid: 1175036' -H 'email: tarakan.sv@gmail.ney'  #=> 0

    # An example Ruby method

    def validate_member(cid, email)
      response = Curl::Easy.http_get("api.vateud.net/members/validate") do |curl|
        curl.headers['cid'] = cid
        curl.headers['email'] = email
      end    
    end

### J. Single member details

This endpoint is of the type: `http://api.vateud.net/members/id/` + `vatsim cid` + format type extension.

Omitting the format type extension will return an html response with the member details 
(part of the API web interface)

The data and logic is exactly the same as with other "members" endpoints with the only difference that
this one only returns the details of a single member, identified by their vatsim CID.

This endpoint allows __optionally__ sending a vACC access token as a __header__ in the following syntax:
_'Authorization: Token token="your-vacc-access-token"'_.

If a valid access token is received, the member details returned will be augmented with 2 extra attribites:
member email address and suspension expiration date (if any). This extra data will only be included if the
submitted vacc token matches the affeccted member vacc.

If no access token is sent or the access token is invalid or the access token does not match the queried
member vacc, then the standart set of public details will be returned, not including the email, etc.


_Examples:_

    http://api.vateud.net/members/id/1264903.json    #=> returns member's details in JSON format  
    http://api.vateud.net/members/id/1092003.xml     #=> returns member's details in XML format  
    http://api.vateud.net/members/id/973575.csv      #=> returns member's details in CSV format  
    http://api.vateud.net/members/id/890112          #=> returns member's details as HTML  

    curl api.vateud.net/members/id/890112.json -H 'Authorization: Token token="valid-access-token"'
                        #=> returns augmented set of member's details (including email) in json format
    curl api.vateud.net/members/id/890112.xml -H 'Authorization: Token token="valid-access-token"'
                        #=> returns augmented set of member's details (including email) in xml format

    curl api.vateud.net/members/id/890112.json -H 'Authorization: Token token="invalid-access-token"'
                #=> returns standart public set of member's details (not including email) in json format
    curl api.vateud.net/members/id/890112.csv -H 'Authorization: Token token="invalid-access-token"'
                        #=> returns standart set of member's details (not including email) in csv format



That's pretty much it! Enjoy, feedback welcome :)