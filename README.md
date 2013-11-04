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
* `Active` - a boolean flag editable by EUD admins and vACC staff on the API web backend. Can be used by
   vACCs to selectively flag certain member for exclusion from their rosters in case of inactivity

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

#### Overriding chart titles

Ocassionally, chart names, as provided from our data sources, might not match the physical chart name. 
We have implemented the logic and interface for easily overriding such discrepancies. If you notice a title issue,
please [submit a task](http://tasks.vateud.net/) to VATEUD7, specifying the airport ICAO and the correct
chart title. 

#### Custom airport charts

Some vACCs prefer to override the real world charts with their own renditions for various reasons:
VATSIM-specific procedures, scenery compatibility, advanced customization, etc.

The API can handle those overrides in the following manner:

* vACCs supply a custom charts index as a CSV file in the legacy VATEUD charts format, as seen
  for example [here](http://www.vacc-sag.org/charts_vateud_local_index.txt)
* CSV format description: the field separator is "|". The only relevant data used by the API to parse
  the file is: ICAO code at position `0`, chart name at position `3` and chart url at position `10`. The
  rest is irrelevant and can be left blank when creating the CSV file.
* vACC staff members with API backend access create a "Custom Charts Source" entry on the backend (vACC Staff Zone)
  defining the URL for the custom CSV listing (pictured below)
* That's it from user perspective, the rest is handled authomatically by the API application

![CustomChartSource](http://i.imgur.com/umgKt64.png)

##### Application logic

* The API pulls the vACC Custom Chart Source listings once per day, parses and injects them in a local DB of custom
  charts
* Whenever an API user sends a request for charts, the API first looks into the custom charts DB to find any matches
  based on the requested icao code. If matches are found, it sends out the custom listings, if matches are not
  found it proceeds to query and pull the RW charts for that airport from charts.aero
* There are no differences in the request and response syntaxes between custom and RW charts: the same calls
  and the same response logic and formats apply, i.e. you get json, xml, csv or html responses in both cases

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

### K. Online stations data by callsign

__This portion of the API is powered by the [vatsim_online](https://rubygems.org/gems/vatsim_online) library.
If you're curious to see in detail how it works and the full array of options it provides, head over
[to the documentation](https://github.com/tarakanbg/vatsim_online#vatsim-online).__


These are public endpoints of the type: "http://api.vateud.net/online/callsign/" + callsign filter + format
type extension

The callsigns can designate both pilot and ATC stations.

The callsign filter is a string of full or partial, one or multiple comma separated callsigns
that will be used to filter out the requested online data.
They are __not__ case sensitive. For example you can use the "baw" filter to show all British Airways flights,
or "loww,aua" filter to show all atc stations for Vienna airport and all Austrian Airlines flights, or 
"ach, afr" filter to show all Air Child and Air France flights, etc

Examples:

    http://api.vateud.net/online/callsign/baw.json        #=> returns all British Airways flights in JSON format  
    http://api.vateud.net/online/callsign/afr.xml         #=> returns all Air France flights in XML format  
    http://api.vateud.net/online/callsign/aua,LOWW.csv    #=> returns all Austrian Airlines flights and all
                                                              Vienna airport stations in CSV format  
    http://api.vateud.net/online/callsign/ach             #=> returns all Air Child flights as HTML (part of the API web interface)
      
    ....etc.....  

__Note:__ The online stations responses are all being cached with expiration time set to 5 minutes.
The online stations data is not limited to EUD, you can use it for any stations on the network.

That's pretty much it! Enjoy, feedback welcome :)


### L. Events management (calendar)

The VATEUD events management and calendar API is designed to solve the issue of having multiple standalone
(isolated) calendar solutions for each vACC and for VATEUD separately and to overcome the limitations of the
existing EUD calendar, which is a self contained "silo" with web interface only, and no ways of programmatically
reading, creating or updating event data. The new system provides event organizers across EUD with
a **single** point of posting and updating their event announcements following the principle of "publish once
(or edit once), display anywhere". This also ensures that all pilots will have the same, full event information
wherever they look.

The events management API provides the following abilities:

1. Create, edit, delete events
  - a) Via web interface
  - b) Programmatically, via authenticated REST-ful API calls
2. Retrieve and scope events
  - in 4 different formats JSON, XML, CSV and __ICS/iCAL__ for integration with calendar tools/apps
  - scoped either globally (all VATEUD events) or per vACC (each vACCs events listing)

These abilities ensure the following use cases are satisfied:

* vACCs don't have to maintain their own calendar systems, they can pull their vACC events from the EUD
  API in any convenient format and just visualize them on their websites.
* vACCs that maintain their own calendar systems can easily synchronize their data with the EUD calendar 
  when creating or updating an event on their end by simultaneously sending calls to the EUD API
* Any 3rd party service can use the events API to list VATEUD events. This is how, for example, the new VATEUD
  website will be getting its event data
* The choice between using web backend for events management or using the RESTful API gives both technical and
  non-technical users/vaccs the opportunity to utilize the system without being inconvenienced

#### Reading (retrieving) event data

For retrieving the __unscoped VATEUD events data__ (for all vaccs), use the following endpoint:
`http://api.vateud.net/events + format type extension`

**Examples:**

    http://api.vateud.net/events.json    #=> returns all EUD events in JSON format
    http://api.vateud.net/events.xml     #=> returns all EUD events in XML format
    http://api.vateud.net/events.csv     #=> returns all EUD events in CSV format
    http://api.vateud.net/events.ics     #=> returns all EUD events in ICS format
    http://api.vateud.net/events         #=> returns all EUD events as HTML listing (part of the API web frontend)


For retrieving the __events data scoped by vACC__ (events by a particular vacc only), use the following endpoint:
`http://api.vateud.net/events/vacc/vacc_code + format type extension`

The list of vACC codes is available at [http://api.vateud.net/subdivisions](http://api.vateud.net/subdivisions)

**Examples:**

    http://api.vateud.net/events/vacc/BHZ.json   #=> returns all Bosnia & Herzegovina events in JSON format
    http://api.vateud.net/events/vacc/AUST.xml   #=> returns all Austria events in XML format
    http://api.vateud.net/events/vacc/GER.csv    #=> returns all Germany events in CSV format
    http://api.vateud.net/events/vacc/GRЕ.ics    #=> returns all Greek events in ICS format
    http://api.vateud.net/events/vacc/BHZ        #=> returns all Bosnia & Herzegovina events as HTML (part of the API web frontend)

For retrieving the __details of an individual event__, use the following endpoint:
`http://api.vateud.net/events/event_id + format type extension`

**Examples:**

    http://api.vateud.net/events/4.json  #=> returns the details with event with id 4 in JSON format
    http://api.vateud.net/events/1.xml   #=> returns the details with event with id 1 in XML format
    http://api.vateud.net/events/2.csv   #=> returns the details with event with id 2 in CSV format
    http://api.vateud.net/events/3.ics   #=> returns the details with event with id 3 in ICS format
    http://api.vateud.net/events/1       #=> returns the details with event with id 1 as HTML (part of the API web frontend)

#### Creating, editing and deleting events programmatically

In order to use the RESTful API CRUD (create, edit and delete endpoints) you'll need an API access token for your vACC.
These 3 endpoints only accept authenticated calls. Read above on how to request an API token.

##### Event record attributes

Each event record can accept the following attributes:

* `title` - the event name
* `subtitle` - snappy short event summary, i.e. "ICAO fully staffed"
* `airports` - a comma separated list of the event airports (ICAO codes)
* `description` - the event description. No length limit, can contain HTML
* `banner_url` - a link to your banner image, if any
* `starts` - starting date and time for the event (zulu) in the following format: "2013-10-27T20:00:00Z". The T letter denotes the beginning of the time string, separating the date and time.
* `ends` - ending date and time for the event (zulu) in the following format: "2013-10-27T20:00:00Z". The T letter denotes the beginning of the time string, separating the date and time.
* `vaccs` - the vACCs (one or many) that are organizing the event. Determined programmatically by the access token, not editable via remote calls
* `id` - unique numeric identifier, returned by the application on create and update calls, not editable
* `weekly` - a boolean flag, can have "true" or "false" values. If used when creaitng events,
  causes the application to create 26 weekly instances of the event (6 months ahead). The day of the week and starting and ending
  times for each instance match the initial event values. If used when editing an existing instance of a weekly
  event causes the changes made to be propagated to all other instances of that weekly event. If the flag is not set
  when editing an instance of a weekly event, only that instance will be affected by the changes.

##### RESTful principle explained

The VATEUD API follows the [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer) convention, meaning you send remote calls to a certain endpoint (optionally
including an id), plus you also send in JSON data for the record that you want published/changed and you also
authenticate yourself on behalf of a vACC with an API token. The __type of HTTP request__ that you're sending in
determines the type of action that you want in the following way:

* __GET__ requests are for __reading__ records
* __POST__ requests are for __creating__ records
* __PUT__ requests are for __updating__ records
* __DELETE__ requests are for __destroying__ records


##### Creating an event record

In order to create an event, you send an HTTP __POST request__ to `http://api.vateud.net/events` with the JSON details
of the new event and with your API token (sent as a HEADER along with the request)

__Example:__

    # Creating a one-time event

    curl -X POST -H "Content-Type: application/json" -d '{"airports":"LBSF,LQSA","banner_url":"http://domain.net/image.jpg",
      "description":"example description, can contain HTML","ends":"2013-10-27T22:00:00Z","starts":"2013-10-27T20:00:00Z",
      "subtitle":"event subtitle","title":"Our Grand Event"}' http://api.vateud.net/events -H 'Authorization: Token token="your-vacc-authorization-token"'

    # Creating a recurring weekly event (by adding a "weekly":"true" attribute)

    curl -X POST -H "Content-Type: application/json" -d '{"airports":"LBSF,LQSA","banner_url":"http://domain.net/image.jpg",
      "description":"example description, can contain HTML","ends":"2013-10-27T22:00:00Z","starts":"2013-10-27T20:00:00Z",
      "subtitle":"weekly event subtitle","title":"Our Weekly Event","weekly":"true"}' http://api.vateud.net/events -H 'Authorization: Token token="your-vacc-authorization-token"'

__Notes:__

* The example is a command line CURL call in a UNIX-based OS. The exact syntax will vary depending on the http client
  implementation and the language you're using. Refer to your http client's documentation for full reference.
* The order of attributes in the JSON string is irrelevant. In the above example they're ordered alphabetically,
  but you can do as you please, just remember to wrap both the attribute name and the attribute value in quotes, use
  colon between the name (label) and the value, and separate the pairs with commas
* It's necessary to specify a header declaring the MIME type of the data that I'm sending: in our case application/json.
* Note: the Authentication token is sent along as a HEADER!
* If the call has been successful and the record is created, the endpoint will return the new record as JSON, including
  all attributes PLUS the newly created record ID. You probably want to catch and store the ID if you want to be able to
  programmatically edit or delete this record in the future.
* The new event will be tagged and assigned to the vACC that corresponds to the authentication token used
* No record will be created without an authentication token
* Sending in the "weekly":"true" attribute will create 26 instances of the event (6 months ahead), with times and days of
  the week matching the ones in the original call.

##### Editing (updating) an event record

In order to edit (update) an event, you send an HTTP __PUT request__ to `http://api.vateud.net/events/event_id` with the JSON details
that you want changed and with your API token (sent as a HEADER along with the request). Note you need to pass the
event ID to the URL

__Example:__

    curl -X PUT -H "Content-Type: application/json" -d '{"subtitle":"New subtitle","title":"New title"}'
       http://api.vateud.net/events/1 -H 'Authorization: Token token="your-vacc-access-token"'

__Notes:__

* You only need to pass the attributes that you want changed, not all attributes. The order is irrelevant.
* In the example above, the record changed has an ID of 1
* The Authentication token is sent along as a HEADER!
* If the call has been successful and the record is updated, the endpoint will return the full record as JSON, including
  all attributes plus the id.
* The record will not be updated (error message returned) without an authentication token
* The record will not be updated (error message returned) if the authentication token's vACC doesn't match
  the event record vACC

##### Deleting an event record

In order to delete an event, you send an HTTP __DELETE request__ to `http://api.vateud.net/events/event_id` with
your API token (sent as a HEADER along with the request). Note you need to pass the event ID to the URL, but you
don't need to send any JSON data at this time

__Example:__

    curl -X DELETE http://api.vateud.net/events/3 -H 'Authorization: Token token="your-vacc-access-token"'

__Notes:__

* In the example above, the record deleted has an ID of 3
* The Authentication token is sent along as a HEADER!
* The record will not be deleted (error message returned) without an authentication token
* The record will not be deleted (error message returned) if the authentication token's vACC doesn't match
  the event record vACC

#### Creating, editing and deleting events via the web backend interface

The backend administrative interface for the VATEUD API is accessible via [http://api.vateud.net/admin](http://api.vateud.net/admin).
There's also a link called "Staff Zone" in the menu pointing that way.

The backend requires registration, which is open to all users.

The backend functionality available to individual users is dependant on the user's roles. Initially all users
start with no roles and they have access to no functionality. When logged in they see a blank dashboard.
So don't panick, when you initially register, log in and see nothing useful :) A user needs to be assigned
one or multiple roles by an admin in order to get backend functionality and menus accessible.

The currently available roles are:

* `admin` - unrestricted access
* `events` - access to events management
* `staff` - access to vACC details and staff lists management

Admins are notified by email when a new user signs up, and after checking their credentials, they'll assign him
roles, usually within the day.

___We will only enable accounts created by vACC staff members.___

Users with an "Events" role will see an interface similar to the one below:

![Events Backend Index](http://i.imgur.com/UPOOl7y.png)

Search and export functionality is available for convenience.

The Add and Edit forms look like this and are self explanatory (the description field supports
rich text formatting and comes with a WYSIWYG editor):

![New Event Form](http://i.imgur.com/MDkr5Ku.png)

The following restrictions apply when manipulating event records via the web backend:

* a user can only edit an event if the event's vACC matches the user vacc
* a user can only delete an event if the event's vACC matches the user vacc
* the weekly checkmark field only has an effect when creating new events: it will trigger the creation of
  52 weekly instances of the event (1 year ahead). Triggering it won't have any effect when editing existing events.

### M. vACC profiles

These endpoints allow fetching the general vACC data, either globally (all EUD subdivisions)
or indivisually per vACC. Through the API vACC data can be distributed and visualized on any
3rd party website, including the new EUD website.

The following attrbiutes are exposed for each vACC:

* `code` - unique identifying subdivision code, as defined in VATSIM database
* `name` - the vACC name
* `website` - the vACC website URL
* `introtext` - introductory description of the vACC
* `official` - boolean flag, marks the vACC as official or unofficial

#### Editing vACC records

With the introduction of this portion of the API, vACC records transition from EUD-managed
to __self-managed__. Each vACC has the ability to edit their own records without being dependant
on EUD staff.

vACC staff members with API accounts and sufficient levels of permission
can edit their vACC profiles via the [backend web interface of the API](http://api.vateud.net/admin).

The web interface for editing vACC records is self explanatory and similar to the pictured below:

![Edit vACC](http://i.imgur.com/0KIbRqm.png)

__Notes:__

* vACC staff members can only edit the record for the vACC they belong to
* All changes are logged, tracked and reversible to prevent abuse or accidental data loss
* Deleting or creating subdivision is, of course, not possible via the interface
* One or more countries can be assigned (associated) with a particular vACC
* The introtext supports HTML and the interface comes with a WYSIWYG editor for that field

#### Reading vACC records

##### Fetching all vACC records

This is a public endpoint of the type: `http://api.vateud.net/subdivisions` + `format type extension`

__Examples:__

    http://api.vateud.net/subdivisions.json   #=> returns all vACCs data in JSON format
    http://api.vateud.net/subdivisions.xml    #=> returns all vACCs data in XML format
    http://api.vateud.net/subdivisions.csv    #=> returns all vACCs data in CSV format
    http://api.vateud.net/subdivisions        #=> returns all vACCs data as HTML (part of the API web interface)

##### Fetching individual vACC data

These are public endpoints of the type: `http://api.vateud.net/subdivisions/` + `vacc code` + `format type extension`

The full list of vACC codes can be found at [http://api.vateud.net/subdivisions](http://api.vateud.net/subdivisions)

__Examples:__

    http://api.vateud.net/subdivisions/BLUX.json  => returns vACC BeLux details in JSON format
    http://api.vateud.net/subdivisions/ITA.xml    => returns vACC Italy details in XML format
    http://api.vateud.net/subdivisions/SLOV.csv   => returns vACC Slovenia details in CSV format
    http://api.vateud.net/subdivisions/BHZ        => returns vACC B&H details as HTML (part of the API web interface)


### N. Self managed vACC Staff Members listings

The VATEUD vACC Staff Members API is designed to enable vACC staff to self-manage and maintain their vACC
staff records, via web interface or programmatically, following the principle of "publish once
(or edit once), display anywhere". It has built-in mechanisms of tracking and confirming staff changes by
EUD staff to avoid abuse or accidental data loss.

The vACC Staff members API provides the following abilities:

1. Create, edit, delete staff members
  - a) Via web interface
  - b) Programmatically, via authenticated REST-ful API calls
2. Retrieve and scope staff members
  - in 3 different formats: JSON, XML, CSV
  - scoped either globally (all vACC staff members) or per vACC (each vACCs staff listing)
  - ability to retrieve the details of an individual vACC staff position

Any 3rd party service can use the staff members API to list vACC staff. This is how, for example, the new VATEUD
website will be getting its staff data, and it can be easily implemented on individual vACC sites as well.

The choice between using web backend for staff management or using the RESTful API gives both technical and
non-technical users/vaccs the opportunity to utilize the system without being inconvenienced.

#### Reading (retrieving) staff members data

For retrieving the __unscoped VATEUD staff members data__ (for all vaccs), use the following endpoint:
`http://api.vateud.net/staff_members` + `format type extension`

**Examples:**

    http://api.vateud.net/staff_members.json    #=> returns all EUD staff members in JSON format
    http://api.vateud.net/staff_members.xml     #=> returns all EUD staff members in XML format
    http://api.vateud.net/staff_members.csv     #=> returns all EUD staff members in CSV format
    http://api.vateud.net/staff_members         #=> returns all EUD staff members as HTML listing (part of the API web frontend)


For retrieving the __staff members data scoped by vACC__ (staff listings for a particular vacc only), use the following endpoint:
`http://api.vateud.net/staff_members/vacc/` + `vacc_code` + `format type extension`

The list of vACC codes is available at [http://api.vateud.net/subdivisions](http://api.vateud.net/subdivisions)

**Examples:**

    http://api.vateud.net/staff_members/vacc/BHZ.json   #=> returns all Bosnia & Herzegovina staff members in JSON format
    http://api.vateud.net/staff_members/vacc/AUST.xml   #=> returns all Austria staff members in XML format
    http://api.vateud.net/staff_members/vacc/GER.csv    #=> returns all Germany staff members in CSV format
    http://api.vateud.net/staff_members/vacc/BHZ        #=> returns all Bosnia & Herzegovina staff members as HTML (part of the API web frontend)

For retrieving the __details of an individual staff position__, use the following endpoint:
`http://api.vateud.net/staff_members/` + `staff member id` + `format type extension`

**Examples:**

    http://api.vateud.net/staff_members/212.json  #=> returns the details for staff member with id 212 in JSON format
    http://api.vateud.net/staff_members/191.xml   #=> returns the details for staff member with id 191 in XML format
    http://api.vateud.net/staff_members/185.csv   #=> returns the details for staff member with id 185 in CSV format
    http://api.vateud.net/staff_members/159       #=> returns the details for staff member with id 159 as HTML (part of the API web frontend)

#### Creating, editing and deleting staff members programmatically

In order to use the RESTful API CRUD (create, edit and delete endpoints) you'll need an API access token for your vACC.
These 3 endpoints only accept authenticated calls. Read above on how to request an API token.

##### Staff member attributes

Each staff member record can accept the following attributes:

* `callsign` - the staff position callsign, i.e. "ACCSLACK5"
* `position` - the position description, i.e. "Leisure Manager"
* `cid` - the Vatsim ID of the person occupying the position. Can be blank for vacant positions
* `email` - the staff position email. Can be blank for vacant positions
* `priority` - mandatory integer (number) attribute, designates the relative order of the posiotion in regards to other positions within the same vACC. I.e. position with priority 1 will be listed abover position with priority 2.
* `vacc_code` - the vACC code of the staff member. Determined programmatically by the access token, not editable via remote calls
* `id` - unique numeric record identifier, returned by the application on create and update calls, not editable

##### RESTful principle explained (again)

The VATEUD API follows the [RESTful](http://en.wikipedia.org/wiki/Representational_state_transfer) convention,
meaning you send remote calls to a certain endpoint (optionally
including an id), plus you also send in JSON data for the record that you want published/changed and you also
authenticate yourself on behalf of a vACC with an API token. The __type of HTTP request__ that you're sending in
determines the type of action that you want in the following way:

* __GET__ requests are for __reading__ records
* __POST__ requests are for __creating__ records
* __PUT__ requests are for __updating__ records
* __DELETE__ requests are for __destroying__ records


##### Creating a staff member record

In order to create an staff member, you send an HTTP __POST request__ to `http://api.vateud.net/staff_members` with the JSON details
of the new position and with your API token (sent as a HEADER along with the request)

__Example:__

    curl -X POST -H "Content-Type: application/json" -d '{"callsign":"ACCBIH8","position":"New Test Position",
        "cid":"12345678","email":"test@mail.net","priority":"8"}' http://api.vateud.net/staff_members 
         -H 'Authorization: Token token="your-vacc-access-token"'

__Notes:__

* The example is a command line CURL call in a UNIX-based OS. The exact syntax will vary depending on the http client
  implementation and the language you're using. Refer to your http client's documentation for full reference.
* The order of attributes in the JSON string is irrelevant, just remember to wrap both the attribute name and the attribute value in quotes, use
  colon between the name (label) and the value, and separate the pairs with commas
* In the example I have added a header specifying the MIME type of the data that I'm sending: in our case application/json.
  Strictly speaking this is not necessary. The application expects json and will recognize and accept it even without Content-Type
  header. Nevertheless it's a general good practice to declare the content type when sending data across, so better do it for consistency.
* Note: the Authentication token is sent along as a HEADER!
* If the call has been successful and the record is created, the endpoint will return the new record as JSON, including
  all attributes PLUS the newly created record ID. You probably want to catch and store the ID if you want to be able to
  programmatically edit or delete this record in the future.
* The new staff member position will be tagged and assigned to the vACC that corresponds to the authentication token used
* No record will be created without an authentication token

##### Editing (updating) a staff member record

In order to edit (update) a staff member, you send an HTTP __PUT request__ to `http://api.vateud.net/staff_members/staff_member_id` with the JSON details
that you want changed and with your API token (sent as a HEADER along with the request). Note you need to pass the
staff member ID to the URL

__Example:__

    curl -X PUT -H "Content-Type: application/json" -d '{"cid":"12345788","email":"test2@mail.net"}'
       http://api.vateud.net/staff_members/474 -H 'Authorization: Token token="your_vacc_access_token"'

__Notes:__

* You only need to pass the attributes that you want changed, not all attributes. The order is irrelevant.
* In the example above, the record changed has an ID of 474
* The Authentication token is sent along as a HEADER!
* If the call has been successful and the record is updated, the endpoint will return the full record as JSON, including
  all attributes plus the id.
* The record will not be updated (error message returned) without an authentication token
* The record will not be updated (error message returned) if the authentication token's vACC doesn't match
  the staff member record vACC

##### Deleting a staff member record

In order to delete a staff member record, you send an HTTP __DELETE request__ to `http://api.vateud.net/staff_members/staff_member_id` with
your API token (sent as a HEADER along with the request). Note you need to pass the event ID to the URL, but you
don't need to send any JSON data at this time

__Example:__

    curl -X DELETE http://api.vateud.net/staff_members/471 -H 'Authorization: Token token="your_vacc_access_token"'

__Notes:__

* In the example above, the record deleted has an ID of 471
* The Authentication token is sent along as a HEADER!
* The record will not be deleted (error message returned) without an authentication token
* The record will not be deleted (error message returned) if the authentication token's vACC doesn't match
  the staff member record vACC

#### Creating, editing and deleting staff members via the web backend interface

The backend administrative interface for the VATEUD API is accessible via [http://api.vateud.net/admin](http://api.vateud.net/admin).
There's also a link called "Staff Zone" in the menu pointing that way.

The backend requires registration, which is open to all users.

The backend functionality available to individual users is dependant on the user's roles. Initially all users
start with no roles and they have access to no functionality. When logged in they see a blank dashboard.
So don't panick, when you initially register, log in and see nothing useful :) A user needs to be assigned
one or multiple roles by an admin in order to get backend functionality and menus accessible.

The currently available roles are:

* `admin` - unrestricted access
* `events` - access to events management
* `staff` - access to vACC details and staff lists management

Admins are notified by email when a new user signs up, and after checking their credentials, they'll assign him
roles, usually within the day.

___We will only enable accounts created by vACC staff members.___

Users with a "Staff" role will see an interface similar to the one below:

![Staff Backend Index](http://i.imgur.com/xixkgph.png)

Search and export functionality is available for convenience.

The Add and Edit forms look like this and are self explanatory:

![New Staff Member Form](http://i.imgur.com/xUJzMGn.png)

The following restrictions apply when manipulating event records via the web backend:

* A user can only edit an staff member if the staff member's vACC matches the user vacc
* A user can only delete an staff member if the staff member's vACC matches the user vacc
* All changes are logged, tracked and reversible to prevent abuse or accidental data loss
* A `vateud_confirmed` flag is attached to each record. The flag is set to "false" by default
  and also reset from "true" to "false" whenever an existing staff member is edited, either
  via the web interface or programmatically. Only EUD
  staff with admin level of access to the API can "confirm" staff member records, thus setting the flag to "true".
  This is to avoid errors and potential abuse, and to make sure EUD staff has an easy way to
  monitor vACC staff changes as they happen. This flag is for internal reference of EUD staff only and has
  no impact of the record's availability.

### O. Airport profiles

The airports API allows vACC to showcase some or all airports in their respective countries,
and make the information available to any 3rd party web service that wants to use it, including
event websites, individual vACC websites and the VATEUD website.

Creating airport records is only possible to the API backend for now. vACC staff members with
API backend access can create, edit and destroy airport profiles.

Only part of the airport data is filled in and maintained by vACCs, and even a smaller subset of
this data is mandatory. The majority of the data listed and available for each airport is obtained
and updated programmatically via the [airdata library](http://rubygems.org/gems/airdata).
If you're interested in the technical details, read the [documentation](https://github.com/tarakanbg/airdata#airdata).

The following attributes are included for each airport:

___vACC provided:___

* `icao` - mandatory, unique. The airport's ICAO identifier. 
* `iata` - mandatory. The airport's IATA code
* `country` - mandatory. The airport's country, chosen from a list of EUD countries
* `major` - a boolean field. Designates an airport as being a "major" one
* `scenery_fs9_link` - link to FS9 scenery
* `scenery_fsx_link` - link to FSX/P3D scenery
* `scenery_xp_link` - link to X-Plane scenery
* `description` - freetext description of the airport. Supports rich text format and the field comes
   with a WYSIWYG editor on the backend

___Automatically obtianed:___

* `name` - the airport's (or city) name
* `elevation` - the airport's elevation in feet
* `ta` - the airport's transition altitude
* `msa` - the airport's minimum safe altitude
* `lat` - the airport's latitude
* `lon` - the airport's longitutde

___Airport runways (automatically obtained)___

* `number` - the runway number (designator)
* `course` - the runway course
* `length` - the runway length in feet
* `elevation` - the runway threshold elevation
* `lat` - the latitude of the runway threshold
* `lon` - the longitude of the runway threshold
* `ils` - boolean; true if the runway is equipped with ILS
* `ils_fac` - the ILS final aproach course
* `ils_freq` - the ILS frequency
* `glidepath` - the ILS glidepath angle. Defaults to 3 degrees for runways without ILS

#### Data structure and format differences

As you can see, it's a big set of data, and it's nested/structured in the API responses,
so that all the primary vacc provided attributes are directly listed in the airport set,
all the automatically obtained general details are grouped in a "data" subset, and all
runways informtion is grouped in a "runways" subset which is nested below "data". The
country data is isolated in a separate "country" subset, giving the country code and
country name attributes.

Hence an exaple JSON repsonse will look like this:

    {"description":"<p><strong>Sarajevo International Airport</strong> description</p>\r\n",
    "iata":"SJJ","icao":"LQSA","major":true,"scenery_fs9_link":"http://vaccbih.info/downloads",
    "scenery_fsx_link":"http://vaccbih.info/downloads","scenery_xp_link":"http://vaccbih.info/downloads",
    "country":{"code":"BA","name":"Bosnia-Herzegovina"},"data":{"elevation":1708,"icao":"LQSA",
    "lat":43.824472,"lon":18.331767,"msa":8500,"name":"SARAJEVO","ta":9500,"runways":[{"course":115,
    "elevation":1643,"glidepath":3.2,"ils":true,"ils_fac":115,"ils_freq":110.7,"lat":43.829542000000004,
    "length":8530,"lon":18.318231,"number":"12"},{"course":295,"elevation":1690,"glidepath":3.0,"ils":false,
    "ils_fac":0,"ils_freq":0.0,"lat":43.821272,"length":8530,"lon":18.340303,"number":"30"}]}}

XML responses are structured in the same way. CSV responses are "flattened" to include all the general
details. Due to the inability of the CSV format to store a subset of arbitrary size, runways information
is not included in the CSV responses.

#### Fetching all EUD airports

These are endpoints of the type: `http://api.vateud.net/airports` + `format type extension`

__Examples:__

    http://api.vateud.net/airports.json   #=> returns all EUD airports in JSON format
    http://api.vateud.net/airports.xml    #=> returns all EUD airports in XML format
    http://api.vateud.net/airports.csv    #=> returns all EUD airports in CSV format
    http://api.vateud.net/airports        #=> returns all EUD airports as HTML (part of the API web interface)

#### Scoping the airports per country

These are endpoints of the type: `http://api.vateud.net/airports/country/` + `country code` + `format type extension`    

The full list of EUD country codes can be seen at [http://api.vateud.net/airports](http://api.vateud.net/airports)

__Examples:__

    http://api.vateud.net/airports/country/BA.json  #=> returns all Bosnia & Herzegovina airports in JSON format
    http://api.vateud.net/airports/country/BA.xml   #=> returns all Bosnia & Herzegovina airports in XML format
    http://api.vateud.net/airports/country/BA.csv   #=> returns all Bosnia & Herzegovina airports in CSV format
    http://api.vateud.net/airports/country/BA       #=> returns all Bosnia & Herzegovina airports as HTML (part of the API web interface)

#### Getting individual airport details

These are endpoints of the type: `http://api.vateud.net/airports/` + `ICAO code` + `format type extension`    

__Examples:__

    http://api.vateud.net/airports/LQSA.json   => returns the details for Sarajevo airport in JSON format
    http://api.vateud.net/airports/LQMO.xml    => returns the details for Mostar airport in XML format
    http://api.vateud.net/airports/LQTZ.csv    => returns the details for Tuzla airport in CSV format
    http://api.vateud.net/airports/LQSA        => returns the details for Sarajevo airport as HTML (part of the API web interface)

#### Creating ad editing airport records

This is done via the API backend by vACC staff with API accounts. The interface is self explanatory and looks
like this:

![Editing airports](http://i.imgur.com/Sl7Hx0V.png)

Staff members can only edit the records of the airports the belong to their respective vACC's countries.

### P. Approved ATC frequencies

#### Fetching all VATEUD approved ATC frequencies

These are endpoints of the type: `http://api.vateud.net/frequencies` + `format type extension`

__Examples:__

    http://api.vateud.net/frequencies.json   #=> returns all EUD ATC freqs in JSON format
    http://api.vateud.net/frequencies.xml    #=> returns all EUD ATC freqs in XML format
    http://api.vateud.net/frequencies.csv    #=> returns all EUD ATC freqs in CSV format
    http://api.vateud.net/frequencies        #=> returns all EUD ATC freqs as HTML (part of the API web interface)

#### Scoping ATC frequencies per vACC

These are endpoints of the type: `http://api.vateud.net/frequencies/` + `vACC code` + `format type extension`    

The full list of vACC codes can be seen at [http://api.vateud.net/frequencies](http://api.vateud.net/frequencies)

__Examples:__

    http://api.vateud.net/frequencies/BHZ.json    => returns all Bosnia freqs in JSON format
    http://api.vateud.net/frequencies/MALT.xml    => returns all Malta freq in XML format
    http://api.vateud.net/frequencies/NETH.csv    => returns all Netherlands freqs in CSV format
    http://api.vateud.net/frequencies/AUST        => returns all Austrian freqs as HTML (part of the API web interface)

### Appendix A. Caching times

#### Backend

No caching on the backend! Data is pulled from the DB on each request.

#### Frontend

* All EUD members: html responses: no caching; json, xml and csv responses: 3 hours
* vACC members: html responses: no caching; json, xml and csv responses: 4 hours
* Members by country: html responses: no caching; json, xml and csv responses: 4 hours
* Members by rating: html responses: no caching; json, xml and csv responses: 4 hours
* Single member details: all formats: 2 hours
* Member validation endpoint: no caching
* vACC profiles: all formats: 2 hours
* Staff member listings: all formats: 5 minutes
* Who's online data: all formats: 5 minutes
* Notams: all formats: 12 hours
* Chars: all formats: 4 hours
* ATC frequencies: all formats: 2 hours
* Events calendar: all formats: 10 minutes
* Airport profiles: all formats: 10 minutes

