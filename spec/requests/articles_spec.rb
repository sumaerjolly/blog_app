require "rails_helper"

RSpec.describe "Articles", type: :request do 
    before do 
        @john = User.create(email: "john@example.com", password: "password")
        @jane = User.create(email: "jane@example.com", password: "password")
        @article = Article.create!(title: "first article", body: "body of first article", user: @john )
    end

    describe 'GET/articles/:id/edit' do 
        context 'with non signed in user' do 
            before { get "/articles/#{@article.id}/edit" }

            it "redirects to do the signup" do 
                expect(response.status).to eq 302
                flash_message = "You need to sign in or sign up before continuing."
                expect(flash[:alert]).to eq flash_message
            end
        end 

        context 'with signed in user who is non creator' do 
            before do 
                login_as(@jane)
                get "/articles/#{@article.id}/edit"
            end
            it "redirects to do the homepage" do
                expect(response.status).to eq 302
                flash_message = "You can only edit your own article"
                expect(flash[:alert]).to eq flash_message
            end
        end

        context 'with signed in user who is the creator' do 
            before do 
                login_as(@john)
                get "/articles/#{@article.id}/edit"
            end
            it "sucessfully edits articles" do
                expect(response.status).to eq 200
            end
        end
    end 

    describe 'GET /articles/:id' do 
        context 'with existing article' do
            before { get "/articles/#{@article.id}" }

            it "handles existing article" do 
                expect(response.status).to eq 200
            end 
        end
        context 'with non-existing article' do 
            before { get "/articles/xxxxx" }

            it "handles non-existing article" do 
                expect(response.status).to eq 302
                flash_message = "The article you are looking for could not be found"
                expect(flash[:alert]).to eq flash_message
            end 
        end
    end

    describe 'DELETE/articles/:id' do
        context 'with non signed in user' do 
            before { delete "/articles/#{@article.id}" }

            it "redirects to do the signup" do 
                expect(response.status).to eq 302
                flash_message = "You need to sign in or sign up before continuing."
                expect(flash[:alert]).to eq flash_message
            end
        end

        context 'with signed in user who is non creator' do 
            before do 
                login_as(@jane)
                delete "/articles/#{@article.id}"
            end
            it "redirects to do the homepage" do
                expect(response.status).to eq 302
                flash_message = "You can only delete your own article"
                expect(flash[:alert]).to eq flash_message
            end
        end

        context 'with signed in user who is the creator' do 
            before do 
                login_as(@john)
                delete "/articles/#{@article.id}"
            end
            it "sucessfully deletes articles" do
                expect(response.status).to eq 302
                flash_message = "Article has been deleted"
                expect(flash[:success]).to eq flash_message
            end
        end
    end
end 