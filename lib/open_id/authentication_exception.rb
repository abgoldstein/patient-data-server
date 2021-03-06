module OpenId
  class AuthenticationException < Exception
    attr_reader :value, :state, :redirect_uri, :description

    ###############################
    # Ctor
    # @params args a hash of the attributes named above, any others are ignored
    def initialize(args)
      @value = args[:value]
      @state = args[:state]
      @redirect_uri = args[:redirect_uri]
      @description = args[:description]
    end
  end
end