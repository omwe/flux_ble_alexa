module Applications
    LIGHT_CONTROL_FILE = File.join( File.expand_path( File.dirname( __FILE__ ) ), 'light_control', 'light_control.rb' )

    class Alexa < Application
        # get_response
        # Inputs: raw request
        # Outputs: response
        def get_response( request_in )
            # Nothing to do with the request for now,
            #   # just check the sensor table
            @request = convert_json_to_hash( request_in )
            type = determine_type
            case type
            when "LaunchRequest"
                response = respond_to_launch
            when "IntentRequest"
                response = respond_to_intent
            end
            return [GOOD_RESPONSE_CODE, {'Content-Type' => 'application/json;charset=UTF-8'}, [convert_hash_to_json( response )]]
        end # get_response
        
        private
        
        # Respond to a Skill Launch Request
        def respond_to_launch
            if Applications.light_on?
                response = turn_light_off
            else
                response = turn_light_on
            end
        end # respond_to_launch
        
        # Respond to a Skill Intent Request
        def respond_to_intent
            intent = @request["request"]["intent"]["name"]
            case intent
            when "TurnOn"
                response = turn_light_on
            when "TurnOff"
                response = turn_light_off
            end
        end # respond_to_intent

        def determine_type
            @request["request"]["type"]
        end # determine_type

        def build_response( spoken_text, sessionAttributes={}, end_session=true )
            version = "1.0"
            response = {
                :version => version,
                :sessionAttributes => sessionAttributes,
                :response => {
                    :outputSpeech => {
                        :type => "PlainText",
                        :text => spoken_text
                    },
                    :shouldEndSession => end_session
                }
            }
        end # build_response
        
        def turn_light_on
            if Applications.light_on?
                message = "Your light is already on"
            else
                Applications.light_on
                `#{LIGHT_CONTROL_FILE} start -- on`
                message = "Turning on your light"
            end
            build_response( message )
        end # turn_light_on
        
        def turn_light_off
            if !Applications.light_on?
                message = "Your light is already off"
            else
                Applications.light_off
                `#{LIGHT_CONTROL_FILE} start -- off`
                message = "Turning off your light"
            end
            build_response( message )
        end # turn_light_off
        
    end # Alexa
end
