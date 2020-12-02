require 'rails_helper'

RSpec.describe "Projects", type: :request do
  context "認証済みのユーザーとして" do
    before do
      @user = FactoryBot.create(:user)
    end

    context "ユーザー認証済みの場合" do
      it "プロジェクトを作成出来ること" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        expect {
          post projects_path, params: { project: project_params }
        }.to change(@user.projects, :count).by(1)
      end
    end
  end
end
