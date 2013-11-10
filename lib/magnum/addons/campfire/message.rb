module Magnum
  module Addons
    class Campfire
      class Message
        attr_reader :build

        def initialize(build)
          unless build.kind_of?(Hash)
            raise ArgumentError, "Hash required"
          end

          @build = Hashr.new(build)
        end

        def to_a
          [
            build.title,
            "Message: #{ build.message }",
            "Commit: #{ build.commit_url }",
            "Build: #{ build.build_url }"
          ]
        end

        def to_s
          to_a.join("\n")
        end
      end
    end
  end
end