require "rails_helper"

RSpec.feature "Showing an article" do
    before do 
        @john = User.create(email: "john@example.com", password: "password")
        @jane = User.create(email: "jane@example.com", password: "password")
        @article = Article.create(title: "first article", body: "body of first article", user: @john )
    end

    scenario "To non singed in user hide the Edit and Delete buttons" do 
        visit "/"
        click_link @article.title

        expect(page).to have_content(@article.title)
        expect(page).to have_content(@article.body)
        expect(current_path).to eq(article_path(@article))
        expect(page).not_to have_link("Edit Article")
        expect(page).not_to have_link("Delete Article")

    end

    scenario "To non creator of article hide the Edit and Delete buttons" do 
        login_as(@jane)
        visit "/"
        click_link @article.title

        expect(page).to have_content(@article.title)
        expect(page).to have_content(@article.body)
        expect(current_path).to eq(article_path(@article))
        expect(page).not_to have_link("Edit Article")
        expect(page).not_to have_link("Delete Article")

    end

    scenario "Signed in user who is the creator can edit and delete" do 
        login_as(@john)
        visit "/"
        click_link @article.title

        expect(page).to have_content(@article.title)
        expect(page).to have_content(@article.body)
        expect(current_path).to eq(article_path(@article))
        expect(page).to have_link("Edit Article")
        expect(page).to have_link("Delete Article")

    end

end