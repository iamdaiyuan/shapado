class Tag
  include Mongoid::Document
  include Mongoid::Timestamps
  include MongoidExt::Storage

  identity :type => String

  field :name,  :type => String
  field :description, :type => String
  field :count, :type => Float, :default => 0.0
  field :langs, :type => Array
  field :color, :type => String
  field :used_at, :type => Time

  file_key :icon, :max_length => 1.megabytes

  referenced_in :group
  referenced_in :user

  index :name
  index :group_id

  validates_uniqueness_of :name, :scope => :group_id, :allow_blank => false

#   def to_param
#     self.name
#   end

  def self.find_file_from_params(params, request)
    if request.path =~ /\/(icon)\/([^\/\.?]+)\/([^\/\.?]+)/
      @group = Group.find($2)
      @tag = Tag.where(:name => $3).first
      case $1
      when "icon"
        @tag.icon
      end
    end
  end
end
