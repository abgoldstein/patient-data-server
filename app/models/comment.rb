class Comment
  include Mongoid::Document

  embedded_in :entry

  field :text, :type => String
  field :author, :type => String
  field :category, :type => String
end
