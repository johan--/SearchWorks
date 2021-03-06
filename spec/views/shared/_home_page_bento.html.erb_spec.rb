require 'spec_helper'

describe 'shared/_home_page_bento.html.erb' do
  context 'catalog controller' do
    before { expect(view).to receive(:controller_name).at_least(:once).and_return('catalog') }

    it 'links the "Articles+" section' do
      render
      expect(rendered).to have_css('h3 a', text: 'Articles+')
    end

    it 'does not link the "Catalog" section' do
      render
      expect(rendered).to have_css('h3', text: 'Catalog')
      expect(rendered).not_to have_css('h3 a', text: 'Catalog')
    end

    it 'links to Bento section' do
      render
      expect(rendered).to have_css('h3', text: 'All of the above')
    end
  end

  context 'articles controller' do
    before { expect(view).to receive(:controller_name).at_least(:once).and_return('articles') }

    it 'links the "Catalog" section' do
      render
      expect(rendered).to have_css('h3 a', text: 'Catalog')
    end

    it 'does not link the "Articles+" section' do
      render
      expect(rendered).to have_css('h3', text: 'Articles+')
      expect(rendered).not_to have_css('h3 a', text: 'Articles+')
    end

    it 'links to Bento section' do
      render
      expect(rendered).to have_css('h3', text: 'All of the above')
    end
  end
end
