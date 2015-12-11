# == Schema Information
#
# Table name: vacancies
#
#  id           :integer          not null, primary key
#  name         :string
#  phone        :string
#  email        :string
#  salary       :decimal(10, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#  validity     :integer
#  state        :string
#

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
  it { should have_many(:skill_items).dependent(:destroy) }
  it { should have_many(:skills).through(:skill_items) }


  context 'name should be present' do
    it { should validate_presence_of(:name) }
  end

  context 'name should be correct length' do
    it { should validate_length_of(:name).is_at_least(2) }
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

  describe "when email address is already taken" do
    before do
      vacancy_with_same_email = @vacancy.dup
      vacancy_with_same_email.email = @vacancy.email.upcase
      vacancy_with_same_email.phone = '+7(222)456-23-45'
      vacancy_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when phone is already taken" do
    before do
      @vacancy_with_same_phone = @vacancy.dup
      @vacancy_with_same_phone.email = 'example_another@mail.ru'
      @vacancy_with_same_phone.save
    end
    it { expect(@vacancy_with_same_phone).not_to be_valid }
  end

  describe 'when email format is valid' do
     it 'should be valid' do
      addresses = %w[vacancy@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
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

  describe 'scopes: ' do
    it 'salary desc order' do
      exp, exis = Vacancy.salary_ord.to_sql, Vacancy.order(salary: :desc).to_sql
      expect(exp).to eq exis
    end

    it 'all published vacancies' do
      exp, exis = Vacancy.to_show.to_sql, Vacancy.where(state: :published).to_sql
      expect(exp).to eq exis
    end

    context 'pagination' do
      it 'when page is 0' do
        exp = Vacancy.pagination(0).to_sql
        exis = Vacancy.offset(0).limit(5).to_sql
        expect(exp).to eq exis
      end

      it 'when page is 1' do
        exp = Vacancy.pagination(1).to_sql
        exis = Vacancy.offset(5).limit(5).to_sql
        expect(exp).to eq exis
      end
    end
  end


end
