require "test_helper"

# Goal: have as many beers tonight as possible.

class OperationPostingTest_v1 < Minitest::Spec
  module Posting::Operation
    class Create < Trailblazer::Operation
      # this could also be written as:
      # TODO

      step :validate
      step :reformat # AI formatting
      step :create_slug
      step :save
      step :notify

      def validate(ctx, params:, **)
        params.any?
      end

      def reformat(ctx, params:, **)
        true
      end

      def create_slug(ctx, **)
        true
      end

      def save(ctx, params:, **)
        ctx[:model] = Posting.new
      end

      def notify(ctx, model:, **)
        model.present?
      end
    end
  end

  it "fails, because we need to learn TRB" do
    result = Posting::Operation::Create.wtf?(params: {})

    assert_equal result.failure?, true
  end
end
