class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightAdvancedSearch::AdvancedSearchBuilder
  include BlacklightRangeLimit::RangeLimitBuilder
  include CJKQuery

  self.default_processor_chain += [:add_advanced_parse_q_to_solr, :add_advanced_search_to_solr]
  self.default_processor_chain += [:database_prefix_search]
  self.default_processor_chain += [:modify_params_for_cjk, :modify_params_for_cjk_advanced]
  self.default_processor_chain += [:consolidate_home_page_params]

  # Override range limit to only add parameters on search pages, not the home page
  def add_range_limit_params(*args)
    super unless on_home_page?
  end

  def consolidate_home_page_params(solr_params)
    return unless on_home_page?

    solr_params['facet.field'] = ['access_facet', 'format_main_ssim', 'building_facet', 'language']
    solr_params['rows'] = 0
  end

  def database_prefix_search(solr_params)
    if page_location.access_point.databases? && blacklight_params[:prefix]
      if blacklight_params[:prefix] == "0-9"
        query = ("0".."9").map do |number|
          "title_sort:#{number}*"
        end.join(" OR ")
      else
        query = "title_sort:#{blacklight_params[:prefix]}*"
      end
      solr_params[:qt] = blacklight_config.lucene_req_handler
      solr_params[:q] = [query, blacklight_params[:q]].compact.join(" AND ")
    end
  end

  def modifiable_params_keys
    %w[q search search_author search_title subject_terms series_search pub_search isbn_search]
  end

  private

  def page_location
    SearchWorks::PageLocation.new(blacklight_params)
  end

  def on_home_page?
    blacklight_params[:q].blank? && blacklight_params[:f].blank? && blacklight_params[:search_field].blank?
  end
end
