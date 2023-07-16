require "test_helper"
# Goal: #left allows error handling.

class OperationPostingTest_v3 < Minitest::Spec
  module Posting::Operation
    class Create < Trailblazer::Operation
      # this could also be written as:
      # TODO

      step :validate
      left :validate_error
      step :reformat # AI formatting
      step :create_slug
      step :save
      step :notify

      def validate(ctx, params:, **)
        return unless params.key?(:content)
        params[:content].size >= 10
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

      def validate_error(ctx, **)
        ctx[:errors] = {content: ["There have been errors."]}
      end
    end
  end

  it "works" do
    result = Posting::Operation::Create.wtf?(params: {content: "Have you ever tried a fresh Gin Dobre?\nIt is a beautif\n"})

    assert_equal result.success?, true
    assert_equal result[:errors], nil
  end

  it "fails" do
    result = Posting::Operation::Create.wtf?(params: {content: "Have yo"})

    assert_equal result.failure?, true
    assert_equal result[:errors].inspect, "{:content=>[\"There have been errors.\"]}"
  end
end
