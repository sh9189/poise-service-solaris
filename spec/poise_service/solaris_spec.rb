#
# Cookbook: poise-service-solaris
# License: Apache 2.0
#
# Copyright 2015, Noah Kantrowitz
# Copyright 2015, Bloomberg Finance L.P.
#
require_relative '../spec_helper'

describe PoiseService::Solaris do
  it 'has a version number' do
    expect(PoiseService::Solaris::VERSION).not_to be nil
  end
end
