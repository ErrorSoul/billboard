require 'rails_helper'

describe Skill do
  before do
    @skill = create :skill
  end

  subject { @skill }

  it { should respond_to(:name) }


  context 'name should be present' do
    it { should validate_presence_of(:name) }
  end

  context 'name should be correct length' do
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_length_of(:name).is_at_most(140) }
  end

  context 'phone should be uniqueness' do
    it { should validate_uniqueness_of(:name) }
  end
end
