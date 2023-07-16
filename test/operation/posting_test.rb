require "test_helper"

class OperationPostingTest < Minitest::Spec
  module Posting::Operation
    class Create < Trailblazer::Operation
      step :validate
      step :reformat # AI formatting
      step :create_slug
      step :save
      step :notify

      def validate(ctx, params:, **)
        params.any?
      end

      def reformat(ctx, validated_input:, **)

      end

      def create_slug(ctx, **)

      end

      def save(ctx, validated_input:, **)

      end

      def notify(ctx, model:, **)

      end
    end
  end

  it "works" do
    result = Posting::Operation::Create.wtf?(params: {})

    assert_equal result.success?, true
  end
end
