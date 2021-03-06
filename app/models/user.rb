class User < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :sub_categories, as: :categorizable, dependent: :destroy, class_name: 'Category'
  has_many :categories, dependent: :destroy

  validates :email, :password, presence: true

  mount_uploader :avatar, AvatarUploader

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
    :confirmable, :omniauthable, omniauth_providers: %i[google github]

  def balance
    Users::Balance.new(self).balance
  end

  def free_balance
    Users::FreeBalance.new(self).call
  end

  delegate :balance_transactions, to: :transactions
  delegate :category_transactions, to: :transactions
  delegate :expense_transactions, to: :transactions
  delegate :last_ten, to: :transactions, prefix: true
  delegate :with_amount, to: :categories, prefix: true
end
