require 'rails_helper'

RSpec.describe Note, type: :model do

  it "FactoryBotでnoteのテストデータ生成" do
    note = FactoryBot.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note's user is #{note.user.inspect}"
  end

  before do
    @user = User.create(
      first_name: "Joe",
      last_name:  "Tester",
      email:      "joetester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
  )
    @project = @user.projects.create(
      name: "Test Project",
  )

  end

  describe "検索機能" do

    before do

      @note1 = @project.notes.create(
        message: "This is the first note.",
        user: @user,
      )

      @note2 = @project.notes.create(
        message: "This is the second note.",
        user: @user,
      )

      @note3 = @project.notes.create(
        message: "First, preheat the oven.",
        user: @user,
      )

    end
    #成功要件
    context "一致するデータが存在する時" do
      it "検索文字列に一致する場合メモを返すこと" do

        expect(Note.search("first")).to include(@note1, @note3)
        expect(Note.search("first")).to_not include(@note2)

      end
    end

    #失敗要件
    context "一致するデータがない時" do
      it "検索結果が0の場合、空のオブジェクトを返すこと" do

        expect(Note.search("message")).to be_empty

      end
    end
  end
end
