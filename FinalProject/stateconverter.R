newwrapdata = data.frame(stringsAsFactors = FALSE)

wrapdata$Category = stateFromLower(wrapdata$Category)


StateCodes=data.frame(
state=as.factor(c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
                  "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME",
                  "MI", "MN", "MO", "MS",  "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
                  "NV", "NY", "OH", "OK", "OR", "PA", "PR", "RI", "SC", "SD", "TN",
                  "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY")),
full=as.factor(c("Alaska","Alabama","Arkansas","Arizona","California","Colorado",
                 "Connecticut","District of Columbia","Delaware","Florida","Georgia",
                 "Hawaii","Iowa","Idaho","Illinois","Indiana","Kansas","Kentucky",
                 "Louisiana","Massachusetts","Maryland","Maine","Michigan","Minnesota",
                 "Missouri","Mississippi","Montana","North Carolina","North Dakota",
                 "Nebraska","New Hampshire","New Jersey","New Mexico","Nevada",
                 "New York","Ohio","Oklahoma","Oregon","Pennsylvania","Puerto Rico",
                 "Rhode Island","South Carolina","South Dakota","Tennessee","Texas",
                 "Utah","Virginia","Vermont","Washington","Wisconsin",
                 "West Virginia","Wyoming"))
)

wrapdata$Codes=StateCodes$state[match(wrapdata$Category,StateCodes$full)]

