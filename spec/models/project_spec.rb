require 'rails_helper'

RSpec.describe Project, type: :model do

  #成功要件
  it "複数のユーザーによる同名のプロジェクト名の使用は許可すること" do
    user = User.create(
      first_name: "Takanori",
      last_name:  "Ariyoshi",
      email:      "takanori@example.com",
      password:   "testpass",
)

    user.projects.create(
      name: "project"
    )

    sample_user = User.create(
      first_name: "sample_first_name",
      last_name: "sample_last_name",
      email: "sample@example.com",
      password: "samplepass",
    )

    new_project = sample_user.projects.build(
      name: "project",
    )

    expect(new_project).to be_valid
  end

  #失敗要件
  it "ユーザーが同一の時、重複したプロジェクト名を許可しないこと" do
    user = User.create(
      first_name: "Takanori",
      last_name:  "Ariyoshi",
      email:      "takanori@example.com",
      password:   "testpass",
    )

    user.projects.create(
      name: "test_project",
    )

    new_project = user.projects.build(
      name: "test_project",
    )

    new_project.valid?

    expect(new_project.errors[:name]).to include("has already been taken")

  end

  describe "期限ステータス" do
    it "締切日が昨日以前の場合ステータスを[遅延]にすること" do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end
    it "締切日が今日の場合ステータスは[通常]にすること" do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end
    it "締切日が明日以降の場合ステータスは[通常]にすること" do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end

  it "" do
    project = FactoryBot.create(:project, :with_notes)
    expect(project.notes.length).to eq 5
  end

end
