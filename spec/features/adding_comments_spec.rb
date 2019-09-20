require "rails_helper"

RSpec.feature "Adding comments to articles" do
    before do 
        @john = User.create(email: "john@example.com", password: "password")
        @jane = User.create(email: "jane@example.com", password: "password")
        @article = Article.create(title: "first article", body: "body of first article", user: @john )
    end
    
    scenario "permit a signed in user to write a comment" do 
        login_as(@jane)

        visit "/"
        click_link @article.title
        fill_in "New Comment", with: "An amazing article"
        click_button "Add Comment"

        expect(page).to have_content("Comment has been created")
        expect(page).to have_content("An amazing article")
        expect(current_path).to eq(article_path(@article.id))

    end 

end 