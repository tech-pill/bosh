module Bosh::Director::Models
  class Deployment < Sequel::Model
    many_to_one  :release
    many_to_many :stemcells
    one_to_many  :job_instances, :class => "Bosh::Director::Models::Instance"
    one_to_many  :vms

    def validate
      validates_presence :name
      validates_unique :name
      validates_format VALID_ID, :name
    end
  end

  Deployment.plugin :association_dependencies, :stemcells => :nullify
end
