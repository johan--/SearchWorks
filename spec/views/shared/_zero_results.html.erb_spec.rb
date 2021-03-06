require "spec_helper"

describe "shared/_zero_results.html.erb" do
  let(:config) {
    Blacklight::Configuration.new do |config|
      config.add_search_field 'search', label: 'All fields'
      config.add_facet_field 'fieldA', label: "A field"
      config.add_facet_field 'fieldB', label: 'Another field'
    end
  }

  before do
    assign(:search_modifier, SearchQueryModifier.new({
      q: "A query",
      f: { 'fieldA' => ["ValueA"], 'fieldB' => ['ValueB'] },
      search_field: 'search_title'
    }, config))
    allow(view).to receive(:controller_name).and_return('catalog')
    allow(view).to receive(:label_for_search_field).and_return('Title')
  end

  it "displays modify your search" do
    render
    expect(rendered).to have_css("h3", text: "Modify your catalog search")
  end

  it "renders text indicating tips to modify the search along with links to the relevant search" do
    render
    expect(rendered).to have_css("a", text: /Title >/)
    expect(rendered).to have_css("li", text: 'Remove limit(s)')
    expect(rendered).to have_css("li", text: /Search all fields/)
  end

  it 'renders search tools' do
    render
    expect(rendered).to have_css("a", text: /Search tools/)
  end

  it 'renders alternate catalog' do
    allow(view).to receive(:show_alternate_catalog?).and_return(true)
    allow(view).to receive(:params).and_return(q: 'test123')
    # set view context /shrug
    lookup_context.view_paths = ['app/views/catalog', 'app/views']
    render
    expect(rendered).to have_css '.alternate-catalog'
  end
end
