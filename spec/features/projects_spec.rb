require 'rails_helper'

RSpec.feature "Projects", type: :feature do

  let(:user) { FactoryBot.create(:user) }
  let(:project) {
    FactoryBot.create(:project,
      name:   "Rspec tutorial",
      owner:  user,
      )
    }

  include LoginSupport
  scenario "ユーザーは新しいプロジェクトを作成する" do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path

    expect{
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario "ユーザーはプロジェクトを完了済みにする" do
    #ユーザーがログイン処理実施
    sign_in user
    visit project_path(project)

    #プロジェクトの詳細画面にcompletedラベルが表示されていないことを確認
    expect(page).to_not have_content "Completed"

    #"complete"ボタンをクリックする
    click_button "Complete"

    #ボタンの表示が完了済みに変更される
    expect(project.reload.completed?).to be true
    expect(page).to have_content "Congratulations, this project is complete!"
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
end
