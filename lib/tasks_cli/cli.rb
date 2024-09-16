require "thor"
require "rainbow"

module TasksCLI
  class CLI < Thor
    desc "list", "List all tasks"
    def list
      manager = TaskManager.new
      print_tasks(manager.all_tasks)
    end

    desc "filter FIELD:VALUE", "Filter tasks by field and value"
    def filter(filter_string)
      manager = TaskManager.new
      key, value = filter_string.split(':')
      filtered_tasks = manager.filter_tasks({ key => value })
      print_tasks(filtered_tasks)
    end

    desc "view NUMBER", "View details of a specific task"
    def view(number)
      manager = TaskManager.new
      task = manager.find_task(number)
      if task
        puts task.detailed_view
      else
        puts Rainbow("Task not found").red
      end
    end

    desc "update NUMBER STATUS", "Update the status of a task"
    def update(number, status)
      manager = TaskManager.new
      manager.update_status(number, status)
    end

    private

    def print_tasks(tasks)
      if tasks.empty?
        puts Rainbow("No tasks found.").yellow
        return
      end

      puts Rainbow("\n%-10s %-30s %-15s %-10s %-25s" % ["Number", "Name", "Status", "Priority", "Last Updated"]).underline
      tasks.each do |task|
        puts "%-10s %-30s %-15s %-10s %-25s" % [
          Rainbow(task.number).cyan,
          Rainbow(task.name.to_s.truncate(30)).magenta,
          task.status_colored,
          task.priority_colored,
          Rainbow(task.updated_at).blue
        ]
      end
      puts "\nTotal tasks: #{Rainbow(tasks.count).green}"
    end
  end
end