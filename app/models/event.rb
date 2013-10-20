class Event < ActiveRecord::Base
  require 'icalendar'
  require 'date'

  attr_accessible :airports, :banner_url, :description, :ends, :starts, :subtitle, :title, :subdivision_ids, :vaccs
  has_paper_trail
  has_and_belongs_to_many :subdivisions
  validates :title, :description, :starts, :ends, :subtitle, :airports, :presence => true

  after_create :assign_subdivisions

  rails_admin do 
    navigation_label 'vACC Staff Zone'

    list do
      field :id do
        column_width 40
      end
      field :title do
        column_width 220
        pretty_value do          
          id = bindings[:object].id
          title = bindings[:object].title
          bindings[:view].link_to "#{title}", bindings[:view].rails_admin.show_path('event', id)
        end
      end
      field :starts
      field :ends
      field :airports
      field :subdivisions    
    end

    edit do
      field :title
      field :subtitle
      field :starts
      field :ends
      field :banner_url
      field :airports
      field :subdivisions

      field :description, :rich_editor do
        config({
          :insert_many => true
        })
      end
    end
  end

  def self.to_csv(options = {})
    columns = ["title", "subtitle", "airports", "banner_url", "description", "starts", "ends"]
    CSV.generate(options) do |csv|
      csv << columns
      all.each do |event|
        csv << event.attributes.values_at(*columns)
      end
    end
  end

  def to_csv_single(options = {})
    columns = ["title", "subtitle", "airports", "banner_url", "description", "starts", "ends"]
    CSV.generate(options) do |csv|
      csv << columns
      csv << self.attributes.values_at(*columns)
    end
    rescue ActiveModel::MissingAttributeError
      columns = ["title", "subtitle", "airports", "banner_url", "description", "starts", "ends"]
      CSV.generate(options) do |csv|
        csv << columns
        csv << self.attributes.values_at(*columns)
      end
  end

  def self.calendar(events)
    cal =  Icalendar::Calendar.new

    cal.timezone do
      timezone_id             "UTC"

      daylight do
        timezone_offset_from  "-0000"
        timezone_offset_to    "-0000"
        timezone_name         "UTC"
        dtstart               "19701101T020000"
        # add_recurrence_rule   "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
      end

      standard do
        timezone_offset_from  "-0000"
        timezone_offset_to    "-0000"
        timezone_name         "UTC"
        dtstart               "19701101T020000"
        # add_recurrence_rule   "YEARLY;BYMONTH=11;BYDAY=1SU"
      end
    end

    for event in events
      cal.event do
        summary       event.title
        dtstart       DateTime.parse(event.starts.strftime("%Y%m%dT%H%M%S"))
        dtend         DateTime.parse(event.ends.strftime("%Y%m%dT%H%M%S"))
        description   event.description
        location      event.airports
        url           "http://api.vateud.net/events/#{event.id}"
        # klass       "PRIVATE"
      end
    end
    cal.to_ical
  end

  def self.calendar_single(event)
    cal =  Icalendar::Calendar.new

    cal.timezone do
      timezone_id             "UTC"
      daylight do
        timezone_offset_from  "-0000"
        timezone_offset_to    "-0000"
        timezone_name         "UTC"
        dtstart               "19701101T020000"
      end

      standard do
        timezone_offset_from  "-0000"
        timezone_offset_to    "-0000"
        timezone_name         "UTC"
        dtstart               "19701101T020000"
      end
    end

    cal.event do
      summary       event.title
      dtstart       DateTime.parse(event.starts.strftime("%Y%m%dT%H%M%S"))
      dtend         DateTime.parse(event.ends.strftime("%Y%m%dT%H%M%S"))
      description   event.description
      location      event.airports
      url           "http://api.vateud.net/events/#{event.id}"
    end
    cal.to_ical
  end

  def assign_subdivisions
    vaccs = self.vaccs.split(",")
    vaccs.each { |v| v.strip! }
    ids = []
    vaccs.each do |v|
      sub = Subdivision.find_by_code(v)
      ids << sub.id
    end
    self.subdivision_ids = ids
  end


end
