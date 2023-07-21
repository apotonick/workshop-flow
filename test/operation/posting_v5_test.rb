require "test_helper"

# Goal: have as many beers tonight as possible.
#       why only tonight?

class PostingsController < ApplicationController
  def create

    if validate(params)
      if reformat
        if create_slug
          model = Posting.create(params)
          if !current_user.admin?
            create_pdf

          end
        end
      end
    else
      render :erroring_form
    end
  end

end





class OperationPostingTest_v1 < Minitest::Spec
  module Posting::Operation
    class Save < Trailblazer::Operation
      step :upload_to_aws
      step :rehash
      step :update_cdn

      def upload_to_aws(ctx, **)
        true
      end

      def rehash(ctx, **)
        true
      end

      def update_cdn(ctx, **)
        true
      end
    end

    class Create < Trailblazer::Operation
      # this could also be written as:
      # TODO

      step :validate
      pass :reformat # AI formatting
      step :create_slug
      step Subprocess(Save),
        In() => [:slug],
        Out() => [:model_from_save]
      step :notify

      def validate(ctx, params:, **)
        params.any? && params.key?(:title)
      end

      def reformat(ctx, params:, **)
      end

      def create_slug(ctx, params:, **)
        ctx[:slug] = params[:title][0..3].downcase
      end

      def save(ctx, params:, **)
        true
      end

      def notify(ctx, slug:, **)
        true
      end
    end

    class Update < Trailblazer::Operation
      step :find_model, Output(:failure) => End(:not_found)

      def find_model(ctx, params:, **)
        model = Posting.find_by(id: params[:id])
      end
    end
  end

  it "updated_at" do
    result = Posting::Operation::Update.wtf?(params: {id: 1})
    puts "@@@@@ #{result.event.inspect}"
  end

  it "creates {slug} and is successful" do
    result = Posting::Operation::Create.wtf?(params: {title: "Time for a bee..brake!"})

    assert_equal result.success?, true
    assert_equal result[:slug], "time"
  end

  it "fails with incorrect {params}" do
    result = Posting::Operation::Create.wtf?(params: {})

    assert_equal result.failure?, true
  end
end
