# frozen_string_literal: true

require "spec_helper"

describe Decidim::Consultations::QuestionTitleScrubber do
  subject { described_class.new }

  def scrub(html)
    Loofah.scrub_fragment(html, subject).to_s
  end

  RSpec::Matchers.define :be_scrubbed do
    match do |actual|
      expect(scrub(actual)).to eq actual
    end

    failure_message do |actual|
      "expected \"#{actual}\" to eq \"#{scrub(actual)}\" after scrubbing"
    end
  end

  RSpec::Matchers.define :be_scrubbed_as do |expected|
    match do |actual|
      expect(scrub(actual)).to eq expected
    end

    failure_message do |actual|
      "expected \"#{actual}\" to eq \"#{expected}\" after scrubbing, scrubbed as \"#{scrub(actual)}\" instead"
    end
  end

  it "does not allow iframes" do
    html = "<iframe frameborder=\"0\" allowfullscreen=\"true\" src=\"url\"></iframe>"
    expect(html).to be_scrubbed_as("")
  end

  it "does not allow comments" do
    html = "<p>Hello, <!-- world! --></p>"
    expect(html).to be_scrubbed_as("<p>Hello, </p>")
  end

  it "does not allow disabled iframes" do
    html = %(<div class="disabled-iframe"><!-- <iframe src="url"></iframe> --></div>)
    expect(html).to be_scrubbed_as("")
  end

  it "allows most basic tags" do
    html = "<a></a><b></b><strong></strong><em></em><i></i><p></p><br>"
    expect(html).to be_scrubbed
  end

  it "does not allow scripts" do
    html = "<script></script>"
    expect(html).to be_scrubbed_as("")
  end

  it "does not allow onerror attributes" do
    html = "<img src=x onerror=alert(1)>"
    expect(html).to be_scrubbed_as("")
  end
end
