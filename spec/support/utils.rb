def sign_in(user, options = {})
  if options[:no_capybara]
     login_as(user, scope: :user)
  else
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

def fill_article(article)
  fill_in "Name", with: article.name
  fill_in "Description", with: article.description
  fill_in "Content", with: article.content
end

