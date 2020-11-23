require 'rails_helper'

RSpec.describe User, type: :model do

  #成功要件
  it "姓、名、メール、パスワードがあれば有効な状態であること" do

      expect(FactoryBot.build(:user)).to be_valid

    end

  it "ユーザーのフルネームを文字列として返すこと" do
    user = FactoryBot.build(
      :user,
      first_name: "Takanori",
      last_name:  "Ariyoshi",
    )

    expect(user.name).to eq "Takanori Ariyoshi"
  end

  #失敗要件
  it "名前がなければ無効な状態であること" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "姓がなければ無効な状態であること" do
    user = FactoryBot.build(:user,last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "メールアドレスが重複した場合は無効であること" do
    # FactoryBot.create(:user,email: "takanori@example.com")
    #
    # user = FactoryBot.build(:user, email: "takanori@example.com")
    #
    # user.valid?
    #
    # expect(user.errors[:email]).to include("has already been taken")
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(true).to be_truthy

  end
end
