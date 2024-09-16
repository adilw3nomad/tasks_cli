require 'csv'
require 'json'
require 'rainbow'

module TasksCLI
  class TaskManager
    def initialize
      @file_path = File.expand_path('~/tasks.csv')
      load_tasks
    end

    def load_tasks
      @tasks = []
      CSV.foreach(@file_path, headers: false) do |row|
        next if row == ["Epic Name", "Ticket Number", "Ticket Name", "Ticket Description", "Priority", "Status", "Relates To", "Blocked By"]
        begin
          parsed_row = row.map { |field| parse_field(field) }
          @tasks << Task.new(parsed_row)
        rescue => e
          puts "Error processing row: #{row.inspect}"
          puts "Error message: #{e.message}"
        end
      end
    rescue CSV::MalformedCSVError => e
      puts Rainbow("Error reading CSV: #{e.message}. Trying to parse with alternative method...").red
      parse_csv_manually
    rescue => e
      puts Rainbow("Unexpected error while loading tasks: #{e.message}").red
      puts e.backtrace
    end

    def parse_field(field)
      return field unless field.start_with?('[') && field.end_with?(']')
      parsed = JSON.parse(field.gsub('=>', ':'))
      [parsed[0], parsed[1]]
    rescue JSON::ParserError
      [nil, field]
    end

    def parse_csv_manually
      @tasks = []
      lines = File.readlines(@file_path)
      lines[1..-1].each do |line|
        fields = line.strip.split(',')
        parsed_fields = fields.map { |field| parse_field(field) }
        @tasks << Task.new(parsed_fields)
      rescue => e
        puts "Error processing line: #{line}"
        puts "Error message: #{e.message}"
      end
    end

    def save_tasks(task_number)
      lines = File.readlines(@file_path)
      File.open(@file_path, 'w') do |file|
        file.puts lines[0].chomp  # Write header as is
        lines[1..-1].each do |line|
          fields = line.strip.split(',').map { |f| parse_field(f) }
          if fields[1][1] == task_number
            task = find_task(task_number)
            updated_line = task.to_csv.map.with_index { |value, index| [fields[index][0], value].to_s }.join(',')
            file.puts updated_line
          else
            file.puts line.chomp  # Write unchanged lines as is
          end
        end
      end
    end

    def all_tasks
      @tasks
    end

    def filter_tasks(criteria)
      @tasks.select do |task|
        criteria.all? { |field, value| task.matches?(field, value) }
      end
    end

    def find_task(number)
      @tasks.find { |task| task.number == number }
    end

    def update_status(number, new_status)
      task = find_task(number)
      if task
        old_status = task.status
        task.instance_variable_set(:@status, new_status)
        task.update_timestamp
        save_tasks(number)
        TasksCLI.logger.info("Updated status of task #{number} from #{old_status} to #{new_status}")
        puts Rainbow("Updated status of task #{number} from #{old_status} to #{new_status}").green
        puts Rainbow("Last updated: #{TasksCLI.format_date(task.updated_at)}").cyan
      else
        TasksCLI.logger.warn("Task not found: #{number}")
        puts Rainbow("Task not found").red
      end
    end
  end
end