require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }
  describe 'ユーザー新規登録' do
    context '成功するとき' do
      it '値が正しいとデータを保存できる' do
        expect(user).to be_valid
      end
    end
    context '失敗するとき' do
      it 'nameが空欄だと登録できない' do
        user.name = nil
        user.valid?
        expect(user.errors.full_messages).to include("Name can't be blank")
      end
      it 'emailが空欄だと登録できない' do
        user.email = ''
        user.valid?
        expect(user.errors.full_messages).to include("Email can't be blank")
      end
      it 'emailの形式が違うと登録できない' do
        user.email = 'wrong@mail'
        user.valid?
        expect(user.errors.full_messages).to include('Email is not an email')
      end
      it 'emailが既に登録されていると登録できない' do
        FactoryBot.create(:user, email: 'test@gmail.com')
        user.email = 'test@gmail.com'
        user.valid?
        expect(user.errors.full_messages).to include('Email has already been taken')
      end
      it 'passwordが空欄だと登録できない' do
        user.password = ''
        user.valid?
        expect(user.errors.full_messages).to include("Password can't be blank")
      end
      it 'passwordが6文字以上だと登録できない' do
        user.password = 'a' * 5
        user.valid?
        expect(user.errors.full_messages).to include('Password is too short (minimum is 6 characters)')
      end
    end
  end
end
