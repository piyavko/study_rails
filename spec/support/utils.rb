
def sign_in(user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def fill_article(article)
  fill_in "Name", with: article.name
  fill_in "Description", with: article.description
  fill_in "Content", with: article.content
end

