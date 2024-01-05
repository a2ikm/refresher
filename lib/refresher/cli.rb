require_relative "./client"

class Refresher::CLI
  def initialize(input: $stdin, output: $stdout)
    @input = input
    @output = output

    @name = nil
    @session = nil
  end

  def start
    login
    repl
  end

  private def login
    begin
      print "Enter your name: "
      @name = gets.chomp
      print "Enter your password: "
      password = gets.chomp

      @session = Refresher::Client::Login.new(@name, password).run
    rescue => e
      puts e.message
      puts
      retry
    end
  end

  private def repl
    loop do
      print "#{@name}> "
      command = gets.chomp

      case command
      when "exit", "quit"
        exit
      when "me"
        res = @session.show_me

        case res
        when Refresher::Client::ApiClient::SuccessResponse
          puts res.data
          puts
        else
          puts res.error
          puts
        end
      end
    end
  end

  private def gets(*args)
    @input.gets(*args)
  end

  private def puts(*args)
    @output.puts(*args)
  end

  private def print(*args)
    @output.print(*args)
  end
end
