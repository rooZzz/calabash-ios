require 'json'

module Calabash
  module Cucumber
    # Module for interacting with CalabashXCUITestServer. This server is responsible for performing
    # gestures (previously performed by UIAutomation).
    module CalabusDriver
      include Calabash::Cucumber::Logging
      include Calabash::Cucumber::HTTPHelpers

      require 'run_loop'

      def self.post(path, data={})
        server = RunLoop::HTTP::Server.new(RunLoop::XCUITest.new('').url)
        request = RunLoop::HTTP::Request.request(path, data)
        client = RunLoop::HTTP::RetriableClient.new(server)
        client.post(request)
      end

      def self.cb_tap_id(id)
        post('/tap/id', { :id => id } )
      end

      def self.cb_tap_mark(mark)
        post('/tap/marked', { :mark => mark } )
      end

      def self.swipe_path(direction, type)
        type = type.to_s
        path = nil
        case direction
          when :up
            path = "swipeUp/#{type}"
          when :down
            path = "swipeDown/#{type}"
          when :left
            path = "swipeLeft/#{type}"
          when :right
            path = "swipeRight/#{type}"
          else
            throw "#{direction} is not a valid direction"
        end
        path
      end

      def self.cb_swipe_id(id, direction)
        post(swipe_path(direction, :id), { :id => id } )
      end

      def self.cb_swipe_mark(mark, direction)
        post(swipe_path(direction, :marked), { :mark => mark })
      end

      def self.cb_type_text_id(id, text)
        post('/typeText/id', { :id => id, text => text })
      end

      def self.cb_type_text_mark(mark, text)
        post('/typeText/marked', { :mark => mark, text => text })
      end

    end
  end
end
