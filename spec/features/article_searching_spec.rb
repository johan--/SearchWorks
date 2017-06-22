require 'spec_helper'

feature 'Article Searching' do
  describe 'Search bar dropdown', js: true do
    scenario 'allows the user to switch to the article search context' do
      visit root_path

      within '.search-dropdown' do
        click_link 'search catalog'

        expect(page).to have_css('.dropdown-menu', visible: true)

        expect(page).to have_css('li.active a', text: /catalog/)
        expect(page).not_to have_css('li.active a', text: /articles/)

        click_link 'articles'
      end

      expect(page).to have_current_path(article_home_path)

      within '.search-dropdown' do
        click_link 'search articles'

        expect(page).to have_css('.dropdown-menu', visible: true)

        expect(page).not_to have_css('li.active a', text: /catalog/)
        expect(page).to have_css('li.active a', text: /articles/)
      end
    end
  end
end