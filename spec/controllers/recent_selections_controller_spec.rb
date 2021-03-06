require "spec_helper"

describe RecentSelectionsController do
  describe "#index" do
    let(:user) { User.create!(email: 'example@stanford.edu', password: 'totallysecurepassword') }
    let!(:cat_bookmark1) { Bookmark.create!(document_id: '1', user: user) }
    let!(:cat_bookmark2) { Bookmark.create!(document_id: '2', user: user) }
    let!(:article_bookmark) { Bookmark.create!(document_id: 'abc__1', user: user, record_type: 'article') }

    it 'returns the counts of article and catalog bookmarks' do
      @controller.stub_chain(:current_or_guest_user, :bookmarks).and_return(Bookmark.all)
      get :index, xhr: true
      expect(response).to render_template('index')
      expect(assigns(:catalog_count)).to eq 2
      expect(assigns(:article_count)).to eq 1
    end
  end
end
