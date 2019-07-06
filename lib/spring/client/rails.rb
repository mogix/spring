require "set"

module Spring
  module Client
    class Rails < Command
      COMMANDS_VIA_SPRING = Set.new %w[
        console runner generate destroy test
      ]

      BYPASS_COMMANDS = Set.new %w[
        credentials:edit
        credentials:show
        dbconsole
        encrypted:edit
        encrypted:show
        new
        secrets:edit
        secrets:setup
        secrets:show
        server
        version
        -h -? --help
        -v --version
      ]

      ALIASES = {
        "g"  => "generate",
        "d"  => "destroy",
        "c"  => "console",
        "s"  => "server",
        "db" => "dbconsole",
        "r"  => "runner",
        "t"  => "test"
      }

      def self.description
        "Run a rails command. " \
        "The following sub commands will use Spring: " \
        "#{COMMANDS_VIA_SPRING.to_a.join ', '}."
      end

      def call
        command_name = ALIASES[args[1]] || args[1]

        if COMMANDS_VIA_SPRING.include?(command_name)
          Run.call(["rails_#{command_name}", *args.drop(2)])
        elsif BYPASS_COMMANDS.include?(command_name) || command_name.nil?
          require "spring/configuration"
          ARGV.shift
          load Dir.glob(Spring.application_root_path.join("{bin,script}/rails")).first
          exit
        else
          Run.call(["rake", *args.drop(1)])
        end
      end
    end
  end
end
