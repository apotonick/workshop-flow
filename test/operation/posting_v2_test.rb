require "test_helper"

# Goal: we can run op with success or failure.
#       we can write to ctx[:model]

class OperationPostingTest_v2 < Minitest::Spec
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

  it "works" do
    result = Posting::Operation::Create.wtf?(params: {content: "Have you ever tried a fresh Gin Dobre?\nIt is a beautif\n"})

    assert_equal result.success?, true
    assert_equal result[:model].class, Posting
    assert_equal result[:model].persisted?, false
  end

  it "fails at {#validate}" do
    result = Posting::Operation::Create.wtf?(params: {})

    assert_equal result.failure?, true
  end
end
