require 'rails_helper'

RSpec.describe Note, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }

  it "ユーザー、プロジェクト、メッセージがあれば作成出来ること" do
    note = Note.new(message:"sample",user: user, project: project,)
    expect(note).to be_valid
  end

  it "メッセージがなければ無効であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "検索機能" do

    let(:note1) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "1"
      )
    }

    let(:note2) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "2"
      )
    }

    let(:note3) {
      FactoryBot.create(:note,
        project: project,
        user: user,
        message: "11"
      )
    }

    #成功要件
    context "一致するデータが存在する時" do
      it "検索文字列に一致する場合メモを返すこと" do

        expect(Note.search("1")).to include(note1, note3)
        expect(Note.search("1")).to_not include(note2)

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
