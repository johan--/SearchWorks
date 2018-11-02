module Extent
  def extent_label
    'Description'
  end

  def extent
    [
      sanitized_format,
      [physical_string, characteristics_string].compact.join(' ')
    ].reject(&:blank?).compact.join(' — ')
  end

  private

  def physical_string
    return nil unless self[:physical].present?
    Array[self[:physical]].flatten.join(', ')
  end

  def characteristics_string
    return nil unless self.marc_characteristics.present?
    self.marc_characteristics.map do |characteristic|
      "#{characteristic.label}: #{characteristic.values.join(' ')}"
    end.join(' ')
  end

  def sanitized_format
    if self[format_key].present?
      self[format_key].reject do |format|
        format == 'Database'
      end.first
    end
  end
end
