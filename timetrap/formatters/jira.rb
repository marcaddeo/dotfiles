require File.join('timetrap','formatters','text')
module Timetrap
  module Formatters

    class Jira < Text
      def initialize entries
        entries.map do |e|
          hours, minutes = Time.at(e.end_or_now.to_i - e.start.to_i).utc.strftime("%H:%M").split(':').map(&:to_i)

          if hours == 0 and minutes < 15
            minutes = 15
          else
            x = (minutes / 15).floor * 15
            y = minutes % 15

            if y >= 5
              x += 15
            end

            minutes = x

            if minutes > 59
              minutes = 0
              hours = hours + 1
            end
          end

          e.duration = (hours * 3600) + (minutes * 60)
          e
        end
        super
      end
    end
  end
end
