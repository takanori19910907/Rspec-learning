require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: "Rspec tutorial",owner: user) }

   let!(:task) { project.tasks.create!(name: "Finish Rspec tutorial") }

  scenario "ユーザーがタスクの状態を切り替える", js: true do

    sign_in user
    go_to_project "Rspec tutorial"
    complete_task "Finish Rspec tutorial"
    expect_complete_task "Finish Rspec tutorial"
    undo_complete_task "Finish Rspec tutorial"
    expect_incomplete_task "Finish Rspec tutorial"

  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed",text: name
      expect(task.reload).to be_completed
    end
  end

  def undo_complete_task(project)
    uncheck project
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed",text: name
      expect(task.reload).to_not be_completed
    end
  end

end
