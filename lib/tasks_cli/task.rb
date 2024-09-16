require 'rainbow'

module TasksCLI
  class Task
    attr_reader :epic, :number, :name, :description, :priority, :status, :relates_to, :blocked_by, :updated_at
    
    def initialize(row)
      @epic = extract_value(row[0])
      @number = extract_value(row[1])
      @name = extract_value(row[2])
      @description = extract_value(row[3])
      @priority = extract_value(row[4])
      @status = extract_value(row[5])
      @relates_to = extract_value(row[6])
      @blocked_by = extract_value(row[7])
      @updated_at = extract_value(row[8]) || Time.now.iso8601
    end

    def extract_value(field)
      return field if field.is_a?(String)
      field.is_a?(Array) ? field[1].to_s.strip : field.to_s.strip
    end

    def to_s
      "#{Rainbow(@number).cyan}: #{Rainbow(@name).bright} (#{status_colored}) - Priority: #{priority_colored} - Updated: #{@updated_at}"
    end

    def detailed_view
      <<~TASK
        #{Rainbow("Epic:").bright} #{@epic}
        #{Rainbow("Number:").bright} #{Rainbow(@number).cyan}
        #{Rainbow("Name:").bright} #{Rainbow(@name).bright}
        #{Rainbow("Description:").bright} #{@description}
        #{Rainbow("Priority:").bright} #{priority_colored}
        #{Rainbow("Status:").bright} #{status_colored}
        #{Rainbow("Relates To:").bright} #{@relates_to}
        #{Rainbow("Blocked By:").bright} #{@blocked_by}
        #{Rainbow("Last Updated:").bright} #{@updated_at}
      TASK
    end

    def to_csv
      [@epic, @number, @name, @description, @priority, @status, @relates_to, @blocked_by, @updated_at]
    end

    def matches?(field, value)
      send(field.to_sym).to_s.downcase.include?(value.to_s.downcase)
    rescue NoMethodError
      false
    end

    def update_timestamp
      @updated_at = Time.now.iso8601
    end

    def status_colored
      case @status.downcase
      when 'to do' then Rainbow(@status).red
      when 'in progress' then Rainbow(@status).yellow
      when 'done' then Rainbow(@status).green
      else Rainbow(@status).white
      end
    end

    def priority_colored
      case @priority.downcase
      when 'high' then Rainbow(@priority).red
      when 'medium' then Rainbow(@priority).yellow
      when 'low' then Rainbow(@priority).green
      else Rainbow(@priority).white
      end
    end
  end
end