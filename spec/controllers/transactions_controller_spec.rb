require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  let(:user) { create(:user) }
  let(:transaction) { create(:transaction, user: user) }

  before(:each) do
    login_user user
  end

  describe 'GET #new' do
    it 'renders the :new template' do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'renders the :edit template' do
      get :edit, params: {id: transaction.id}
      expect(response).to render_template :edit
    end
  end

  describe 'GET #index' do
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #search' do
    it 'has a 200 status code' do
      get :search
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do
    context 'when valid' do
      it 'creates transaction' do
        expect do
          post :create, params: {transaction: attributes_for(:transaction)}
        end.to change(Transaction, :count).by(1)
      end

      it 'redirects after create' do
        post :create, params: {transaction: attributes_for(:transaction)}
        expect(response).to redirect_to root_path
      end
    end

    context 'where not valid' do
      it 'not creates new transaction' do
        expect do
          post :create, params: {transaction: {amount: nil}}
        end.to_not change(Transaction, :count)
      end

      it 'render :new template' do
        post :create, params: {transaction: {amount: nil}}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    context 'when valid' do
      let(:amount) { Faker::Number.digit }
      let(:date) { Faker::Date.between_except(1.year.ago, 1.year.from_now, Date.current) }
      let(:params) do
        {
          id: transaction.id,
          transaction: attributes_for(:transaction,
            amount: amount,
            date: date)
        }
      end

      before { put :update, params: params }

      it 'updates transaction' do
        transaction.reload
        expect(transaction.amount).to eq(amount)
        expect(transaction.date).to eq(date)
      end

      it 'redirects after update' do
        put :update, params: {id: transaction.id, transaction: attributes_for(:transaction)}
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when not valid' do
      let(:init_amount) { transaction.amount }
      let(:init_date) { transaction.date }
      let(:params) do
        {
          id: transaction.id,
          transaction: attributes_for(:transaction,
            amount: nil,
            date: nil)
        }
      end

      before { put :update, params: params }

      it 'not updates transaction' do
        transaction.reload
        expect(transaction.amount).to eq(init_amount)
        expect(transaction.date).to eq(init_date)
      end

      it 'render :edit template' do
        put :update, params: {
          id: transaction.id,
          transaction: attributes_for(:transaction,
            amount: nil,
            date: nil)
        }
        expect(response).to render_template :edit
      end
    end
  end
end