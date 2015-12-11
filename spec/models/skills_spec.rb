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
    it { should validate_length_of(:name).is_at_least(2) }
    it { should validate_length_of(:name).is_at_most(140) }
  end

  context 'phone should be uniqueness' do
    it { should validate_uniqueness_of(:name) }
  end

  describe "when name is already taken" do
    before do
      @skill_with_same_name = @skill.dup
      @skill_with_same_name.name = @skill.name.upcase
      @skill_with_same_name.save
    end
    it { expect(@skill_with_same_name).not_to be_valid }
  end
end
