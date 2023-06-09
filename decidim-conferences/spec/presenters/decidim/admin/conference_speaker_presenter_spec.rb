# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Admin::ConferenceSpeakerPresenter, type: :helper do
    let(:conference_speaker) do
      build(:conference_speaker, full_name: "Full name")
    end

    describe "name" do
      subject { described_class.new(conference_speaker).name }

      it { is_expected.to eq "Full name" }

      context "when speaker is an existing user" do
        let(:user) { build(:user, name: "Julia G.", nickname: "julia_g") }
        let(:conference_speaker) { build(:conference_speaker, full_name: "Full name", user:) }

        it { is_expected.to eq "Julia G. (@julia_g)" }
      end
    end
  end
end
