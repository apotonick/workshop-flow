require "test_helper"

class PolicyTest < Minitest::Spec
  class Policy < Trailblazer::Operation
    step :root?, Output(:success) => End(:success), Output(:failure) => Track(:success)
    step :owner?
    step :group_admin?

    def root?(ctx, root: false, **)

    end

    def owner?(ctx, owner: false, **)

    end

    def group_admin?(ctx, group_admin: false, **)

    end
  end

  it "what" do
    result = Policy.wtf?({})
    assert_equal result.success?, false
  end
end
