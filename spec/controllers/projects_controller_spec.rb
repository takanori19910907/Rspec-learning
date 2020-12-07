require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do

  describe "#index" do
    context "認証済みの場合" do
      before do
        @user = FactoryBot.create(:user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :index
        aggregate_failures do
          expect(response).to be_success
          expect(response).to have_http_status "200"
        end
      end
    end

    context "認証されていない場合" do
      it "302(リダイレクト)レスポンスを返すこと" do
        get :index
        expect(response).to have_http_status "302"
      end

      it"サインイン画面にリダイレクトすること" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#show" do

    context "認証済みの場合" do
      before do
        @user = FactoryBot.create(:user)
        @project =FactoryBot.create(:project, owner: @user)
      end

      it "正常にレスポンスを返すこと" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to be_success
      end
    end

    context "認証されていない場合" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "ダッシュボード画面にリダイレクトすること" do
        sign_in @user
        get :show, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do

    context "認証済みの場合" do
      before do
        @user = FactoryBot.create(:user)
      end

      context "paramsの値が有効な属性値の場合" do
        it "プロジェクトを作成出来ること" do
          project_params = FactoryBot.attributes_for(:project)
          #ハッシュ形式でFactoryBotの :projectの中身をproject_paramsに保存
          sign_in @user
          expect{
            post :create, params: {project: project_params}
          }.to change(@user.projects, :count).by(1)
          #project_paramsをpostリクエストで送信し、結果としてprojectのレコードが1つ増えること
        end
      end

      context "paramsの値が無効な属性値の場合" do
        it "does not add a project" do
          project_params = FactoryBot.attributes_for(:project, :invalid)
          sign_in @user
          expect {
            post :create, params: { project: project_params }
          }.to_not change(@user.projects, :count)
        end
      end
    end

    context "認証されていない場合" do
      it "302(リダイレクト)レスポンスを返すこと" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        post :create, params: { project: project_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#update" do

    context "認可されている場合" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトを更新出来ること" do
        project_params = FactoryBot.attributes_for( :project, name: "change_name" )
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "change_name"
      end
    end

    context "認可されていない場合" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project,owner: other_user,name: "Same Old Name")
      end

      it "プロジェクトの更新処理に失敗すること" do
        project_params = FactoryBot.attributes_for(:project, name: "change_name")
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(@project.reload.name).to eq "Same Old Name"
      end

      it "ダッシュボード画面にリダイレクトすること" do
        project_params = FactoryBot.attributes_for(:project)
        sign_in @user
        patch :update, params: { id: @project.id, project: project_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    context "認可されている場合" do
      before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
      end

      it "プロジェクトを削除出来ること" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to change(@user.projects, :count).by(-1)
      end
    end

    context "認可されていない場合" do
      before do
        @user = FactoryBot.create(:user)
        other_user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: other_user)
      end

      it "プロジェクトの削除処理に失敗すること" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @project.id }
        }.to_not change(Project, :count)
      end

      it "ダッシュボード画面にリダイレクトすること" do
        sign_in @user
        delete :destroy, params: { id: @project.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#complete" do
    context "認証済みの場合" do
      let!(:project) { FactoryBot.create(:project, completed: nil) }
      before do
        sign_in project.owner
      end

      describe "処理に失敗した場合" do
        before do
          allow_any_instance_of(Project).
          to receive(:update_attributes).
          with(completed: true).
          and_return(false)
        end

        it "プロジェクト画面にリダイレクトすること" do
          patch :complete, params: { id: project.id }
          expect(response).to redirect_to project_path(project)
        end

        it "失敗のフラッシュメッセージを表示すること" do
          patch :complete, params: { id: project.id }
          expect(flash[:alert]).to eq "Unable to complete project"
        end
      end
    end
  end
end
