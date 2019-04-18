require 'sendgrid-ruby'
require 'yaml'

# Sends email with library contents
class Mailer
  include SendGrid

  attr_accessor :response, :email, :api_key

  def initialize(library = nil)
    open
    from = SendGrid::Email.new(email: 'Gabnix@Goblin.com')
    to = SendGrid::Email.new(email: email)
    subject = 'Recent Games'
    content = if library.nil?
                SendGrid::Content.new(type: 'text/plain', value: 'None Available')
              else
                SendGrid::Content.new(type: 'text/plain', value: content_value(library))
              end
    mail = SendGrid::Mail.new(from, subject, to, content)

    sg = SendGrid::API.new(api_key: api_key)

    @response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts "Email sent to #{email} with code #{response.status_code}."
  end

  private

  def content_value(library)
    header = "Pshhh... Shkohhh... Gabnix is wanting to give videoplay wordnames and moonwheel times.\n\n"
    header += "Eyelook below and write to moonwheel.\n\n\n"

    body = library.to_s

    header + body
  end

  def open
    data = YAML.load_file('config.yml')
    @api_key = data['api_key']
    @email = data['email']
  end
end
