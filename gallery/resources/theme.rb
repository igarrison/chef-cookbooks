actions :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :cookbook, :kind_of => String, :default => "gallery3"

def initialize(*args)
  super
  @action = :create
end
