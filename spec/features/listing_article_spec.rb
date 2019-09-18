require "rails_helper"

RSpec.feature "Listing Articles" do
    before do 
        @article1 = Article.create(title: "first article", body: "body of first article" )
        @article2 = Article.create(title: "second article", body: "body of second article" )
    end 

    scenario "A user lists all articles" do 
        visit "/"

        expect(page).to have_content(@article1.title)
        expect(page).to have_content(@article1.body)
        expect(page).to have_content(@article2.title)
        expect(page).to have_content(@article2.body)
        expect(page).to have_link(@article1.title) 
        expect(page).to have_link(@article2.title) 
    end

    scenario "A user has no articles" do 
        Article.delete_all
        visit "/"

        expect(page).not_to have_content(@article1.title)
        expect(page).not_to have_content(@article1.body)
        expect(page).not_to have_content(@article2.title)
        expect(page).not_to have_content(@article2.body)
        expect(page).not_to have_link(@article1.title) 
        expect(page).not_to have_link(@article2.title)

        within("h1#no-articles") do 
            expect(page).to have_content("No Articles Created")
        end
    end

end