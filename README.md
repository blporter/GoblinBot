# GoblinBot
Sends an email notification containing recently released PS4 games.

Uses [Nokogiri](https://github.com/sparklemotion/nokogiri) and [Mechanize](https://github.com/sparklemotion/mechanize) to parse game data.

Uses [SendGrid](https://sendgrid.com/) to deal with email notifications.

To use this, a SendGrid API key and the email to send to should be listed in a config.yml file within the data directory. Then simply compile main.rb.
