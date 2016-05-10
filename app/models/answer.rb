class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy
  validates :answer, :presence => true
  validates :user_id, :uniqueness => {:scope => :question_id, message: "you are not allowed to answer again this question...If any changes,you will edit your existing answer!"}
end
