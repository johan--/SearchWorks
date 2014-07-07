class LiveLookup
  delegate :to_json, to: :records
  def initialize(ids)
    @ids = [ids].flatten.compact
  end

  private

  def records
    @records ||= response.xpath('//record').map do |record|
      LiveLookup::Record.new(record).to_json
    end
  end

  def response
    @response ||= Nokogiri::XML(response_xml)
  end

  def response_xml
    @response_xml ||= begin
      Faraday.new(live_lookup_url).get.body
    rescue Faraday::ConnectionFailed
      nil
    end
  end

  def live_lookup_url
    "#{Settings.LIVE_LOOKUP_URL}?#{live_lookup_query_params}"
  end
  def live_lookup_query_params
    if multiple_ids?
      "search=holdings&#{mapped_ids}"
    else
      "search=holding&id=#{@ids.first}"
    end
  end
  def mapped_ids
    @ids.each_with_index.map do |id, index|
      "id#{index}=#{id}"
    end.join('&')
  end
  def multiple_ids?
    @ids.length > 1
  end
  class Record
    def initialize(record)
      @record = record
    end
    def to_json
      {
        barcode: barcode,
        due_date: due_date,
        current_location: current_location
      }.to_json
    end
    def barcode
      @record.xpath('.//item_record/item_id').text
    end

    def due_date
      return nil if !due_date_value.present? || due_date_value == "NEVER"
      due_date_value.gsub(',23:59', '')
    end

    def due_date_value
      @record.xpath('.//item_record/date_time_due').map(&:text).last
    end

    def current_location
      return nil if (location = Holdings::Location.new(current_location_code)).code == "CHECKEDOUT"
      location.name
    end

    def current_location_code
      @record.xpath('.//item_record/location').map(&:text).last
    end

  end
end