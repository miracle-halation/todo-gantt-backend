require 'rails_helper'

RSpec.describe 'V1::Auth::Registrations', type: :request do
  describe 'POST /v1/auth' do
    context '成功するとき' do
      it '値が正常だと登録に成功してログインデータを返す' do
        test_params = { name: 'test', email: 'test@example.com', password: 'testtest' }
        expect { post v1_user_registration_path, params: test_params }.to change(User, :count).by(1)
        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        last_user = User.last
        expect(json['data']['id']).to eq last_user.id
      end
    end
    context '失敗するとき' do
      it '必要な値が空だと保存に失敗してエラーを返す' do
        test_params = { email: '', password: '' }
        expect { post v1_user_registration_path, params: test_params }.to change(User, :count).by(0)
        expect(response.status).to eq(422)
        json = JSON.parse(response.body)
        expect(json['data']['id']).to be nil
      end
    end
  end
  describe 'POST /v1/auth/sign_in' do
    let!(:user) { FactoryBot.create(:user, email: 'test@example.com', password: 'testtest') }
    context '成功するとき' do
      it '既に登録されている値だと必要な値を返す' do
        test_params = { email: 'test@example.com', password: 'testtest' }
        post v1_user_session_path, params: test_params
        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        expect(json['data']['email']).to eq user.email
      end
    end
    context '失敗するとき' do
      it '登録されていないemailだとログインに失敗してエラーを返す' do
        test_params = { email: 'test_fail@example.com', password: 'testtest' }
        post v1_user_session_path, params: test_params
        expect(response.status).to eq(401)
        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors'][0]).to eq 'Invalid login credentials. Please try again.'
      end
      it 'パスワードが間違っているとログインに失敗してエラーを返す' do
        test_params = { email: 'test@example.com', password: 'testtestfail' }
        post v1_user_session_path, params: test_params
        expect(response.status).to eq(401)
        json = JSON.parse(response.body)
        expect(json['success']).to be false
        expect(json['errors'][0]).to eq 'Invalid login credentials. Please try again.'
      end
    end
  end
end
