require 'rails_helper'

describe Vacancy do

  before do
    @vacancy = create :vacancy
  end

  subject { @vacancy }

  %i(
   name
   salary
   email
   phone
   published_at
   validity
   state
  ).each do |attr|
    it { should respond_to(attr) }
  end

  it { should be_valid }

  context 'name should be present' do
    it { should validate_presence_of(:name) }
  end

  context 'name should be correct length' do
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_length_of(:name).is_at_most(140) }
  end

  context 'state should be present' do
    it { should validate_presence_of(:state) }
  end

  context 'email should be present' do
    it { should validate_presence_of(:email) }
  end

  context 'phone should be present' do
    it { should validate_presence_of(:phone) }
  end

  context 'email should be uniqueness' do
    subject { build :vacancy }
    it { should validate_uniqueness_of(:email) }
  end


  context 'phone should be uniqueness' do
    #subject { create :vacancy }
    it { should validate_uniqueness_of(:phone).case_insensitive }
  end

  context 'validity should be present' do
    it { should validate_presence_of(:validity) }
  end

  context 'published_at should be present' do
    it { should validate_presence_of(:published_at) }
  end

  context 'salary should be valid' do
    it { should_not allow_value(-1).for(:salary) }
    it { should allow_value(0).for(:salary) }
  end

  context 'validity should be valid' do
    it { should_not allow_value(-1).for(:validity) }
    it { should allow_value(0).for(:validity) }
  end

  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @vacancy.email = invalid_address
        expect(@vacancy).not_to be_valid
      end
    end
  end

  describe 'when email format is valid' do
     it 'should be valid' do
      addresses = %w[user@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @vacancy.email=valid_address
        expect(@vacancy).to be_valid
      end
    end
  end

  describe 'when  validity + published'  do
    context ' < DateTime.now' do
      let(:unpublished_vacancy) do
        create :vacancy, :in_the_past, :validity_unpublished
      end
      let(:date_now) { Date.now }

      it 'state should be unpublished' do
        expect(unpublished_vacancy.state).to eq('unpublished')
      end
    end

    context ' == DateTime.now' do
      let(:published_vacancy) do
        create :vacancy, :in_the_past, :validity_equal
      end
      let(:date_now) { Date.now }

      it 'state should be published' do
        expect(published_vacancy.state).to eq('unpublished')
      end
    end

    context ' > DateTime.now' do
      let(:published_vacancy) do
        create :vacancy, :in_the_past, :validity_published
      end
      let(:date_now) { Date.now }

      it 'state should be published' do
        expect(published_vacancy.state).to eq('published')
      end
    end
  end

end
