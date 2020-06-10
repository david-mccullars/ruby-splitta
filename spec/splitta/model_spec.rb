require 'spec_helper'

describe Splitta::Model do
  subject { Splitta::Model.instance }

  specify 'inspect' do
    expect(subject.inspect).to match(/\A#<Splitta::Model:\d+>\z/)
  end
end
