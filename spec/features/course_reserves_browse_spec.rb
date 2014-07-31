require 'spec_helper'

feature 'Course reserves browse', js: true do
  scenario 'should have correct manual route' do
    visit '/reserves'
    expect(page).to have_css('h1', text: 'Browse course reserves')
  end
  scenario 'should have search fields dropdown' do
    visit course_reserves_path
    expect(page).to have_css('select.search_field')
  end
  scenario 'should activate the datatables plugin correctly' do
    visit course_reserves_path
    expect(page).to have_css('#course-reserves-browse_info')
    expect(page).to have_css('#course-reserves-browse_filter')
    expect(page).to have_css('#course-reserves-browse_length')
    expect(page).to have_css('#course-reserves-browse_paginate')
    expect(page).to have_css('label', text: 'per page')
    expect(page).to have_css('li.paginate_button.active span', text: 1)
    expect(page).to have_css('ul.pagination li:nth-child(2)', text: 'Next')
  end
  scenario 'should have a link in the browse dropdown' do
    visit root_path

    within("#search-navbar .browse-dropdown") do
      click_link "Browse"

      expect(page).to have_css('li a', text: 'Course reserves', visible: true)
      click_link 'Course reserves'
    end

    expect(page).to have_css('h1', text: 'Browse course reserves')
  end
end