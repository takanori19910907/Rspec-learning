require 'rails_helper'

RSpec.describe TasksController, type: :controller do

  include_context "project setup"

  describe "#show" do
    it "JSON形式でレスポンスを返すこと" do
      sign_in user
      get :show, format: :json,
        params: { project_id: project.id, id: task.id }
      expect(response).to have_content_type :json
    end
  end

  describe "#create" do

    it "JSON形式でレスポンスを返すこと" do
      new_task = { name: "New task test" }
      sign_in user
      post :create, format: :json,
        params: { project_id: project.id, task: new_task }
      expect(response).to have_content_type :json
    end

    it "新しいタスクを作成すること" do
      new_task = { name: "new task test" }
      sign_in user
      expect {
      post :create, format: :json,
        params: { project_id: project.id, task: new_task }
      }.to change(project.tasks, :count).by(1)
    end

    it "認証を要求すること" do
      new_task = { name: "New task test" }
      expect {
        post :create, format: :json,
          params: { project_id: project.id, task: new_task }
        }.to_not change(project.tasks, :count)
      expect(response).to_not be_success
    end

  end

end
