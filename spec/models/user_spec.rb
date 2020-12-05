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
  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  
end
