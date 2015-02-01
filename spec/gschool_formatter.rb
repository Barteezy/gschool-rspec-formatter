require 'faraday'
class GSchoolFormatter < RSpec::Core::Formatters::ProgressFormatter
  # This registers the notifications this formatter supports, and tells
  # us that this was written against the RSpec 3.x formatter API.
  # RSpec::Core::Formatters.register self, :example_started

  RSpec::Core::Formatters.register self, :example_passed, :example_pending, :example_failed, :start_dump

  def initialize(*args)
    @things = []
    super
  end

  def example_passed(_notification)
    @things << _notification
    super
  end

  def example_pending(_notification)
    @things << _notification
    super
  end

  def example_failed(_notification)
    @things << _notification
    super
  end

  def start_dump(_notification)
    conn = Faraday.new(:url => 'http://localhost:3000') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    token = "1234"
    response = conn.post do |req|
      req.url '/test_results'
      req.headers['X-Auth-Token'] = token
      req.body = @things.to_json
    end
  



    # right here: post this as json to students.gschool.it
    # turn @things into an array of hashes or hash of hashes
    # post with faraday, with that hash as the body
    # post payload as JSON instead of "www-form-urlencoded" encoding:
    # post with the student's credentials
    # conn.post do |req|
    #   req.url '/api/test_runs'
    #   req.headers['X-Auth-Token'] = token
    #   req.body = @things.to_json
    # end
    #
    # in students.gschool.it - you create an endpoint
    # somehow we have to pass up data about which exercise it is
    # we have to use the user's auth token, so we know who's running it
    # we have to store this test run in some json field
    # package this up as a gem
    # instructors need to make the default formatter somehow

    # nice to have later....
    # if the student doesn't have their credentials on start, ask them to login
    # some generator for exercises for instructors

    # TODO: if students run a different formatter, we don't get results :(
    # maybe.... monkey patch
    super
  end

  # def initialize(output)
  #   @output = output
  # end
  #
  # def example_started(notification)
  #   @output << "example: " << notification.example.description
  # end
end
