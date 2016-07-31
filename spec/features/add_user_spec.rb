require './spec/spec_helper'

feature 'User sign up' do
  scenario 'User can visit sign up page' do
    visit '/users/new'
    expect(page.status_code).to eq 200
    find_field('Email').value
    find_field('Password').value
    expect(page).to have_button('Sign up')
  end

  scenario 'New user is created' do
    expect{ sign_up }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, user@email.com')
    expect(User.first.email).to eq('user@email.com')
  end

  scenario 'it requires password confirmation' do
    expect{ sign_up(password_confirmation: 'WrongPW') }.not_to change(User, :count)
  end

  scenario "I can't sign up without an email address" do
    expect { sign_up(email: nil) }.not_to change(User, :count)
  end

  scenario 'it raises an error if password does not match' do
    expect { sign_up(password_confirmation: 'wrongPW') }.not_to change(User, :count)
    expect(current_path).to eq('/users')
    expect(page).to have_content 'Password and confirmation password do not match'
  end
 end
