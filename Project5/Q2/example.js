d3.text("./presidents.csv", function(data) {
                var CSVrowdata = d3.csvParseRows(data);

                var container = d3.select("body")
                    .append("table")

                    .selectAll("tr")
                        .data(CSVrowdata).enter()
                        .append("tr")

                    .selectAll("td")
                        .data(function(d) { return d; }).enter()
                        .append("td")
                        .text(function(d) { return d; });
            });
