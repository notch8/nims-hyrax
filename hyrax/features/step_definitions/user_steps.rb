include Warden::Test::Helpers

Given(/^an? (general|admin) user$/) do |user_type|
  @user = FactoryBot.create(:user, user_type.to_sym)
end

Given(/^I am logged in$/) do
  login_as @user
end

Given(/^I am logged in as an? (general|admin) user$/) do |user_type|
  step "a #{user_type} user"
  step 'I am logged in'
end