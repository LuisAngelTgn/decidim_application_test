# frozen_string_literal: true

require "spec_helper"

describe Decidim::Meetings::Metrics::MeetingFollowersMetricMeasure do
  let(:day) { Time.zone.yesterday }
  let(:organization) { create(:organization) }
  let(:not_valid_resource) { create(:dummy_resource) }
  let(:participatory_space) { create(:participatory_process, :with_steps, organization:) }
  let(:meeting_component) { create(:meeting_component, :published, participatory_space:) }
  let(:meeting) { create(:meeting, component: meeting_component, created_at: day) }
  let!(:follows) { create_list(:follow, 5, followable: meeting, created_at: day) }
  let!(:old_follows) { create_list(:follow, 5, followable: meeting, created_at: day - 1.week) }

  context "when executing class" do
    it "fails to create object with an invalid resource" do
      manager = described_class.new(day, not_valid_resource)

      expect(manager).not_to be_valid
    end

    it "calculates" do
      result = described_class.new(day, meeting_component).calculate

      expect(result[:cumulative_users].count).to eq(10)
      expect(result[:quantity_users].count).to eq(5)
    end

    it "does not found any result for past days" do
      result = described_class.new(day - 1.month, meeting_component).calculate

      expect(result[:cumulative_users].count).to eq(0)
      expect(result[:quantity_users].count).to eq(0)
    end
  end
end
