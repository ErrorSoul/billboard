require 'rails_helper'

describe Employee do

  before do
    @employee = create :employee
  end

  subject { @employee }

  %i(
   first_name
   middle_name
   last_name
   salary
   email
   phone
   status
  ).each do |attr|
    it { should respond_to(attr) }
  end

  it { should be_valid }
  it { should have_many(:skill_items).dependent(:destroy) }
  it { should have_many(:skills).through(:skill_items) }

  context 'first_name should be present' do
    it { should validate_presence_of(:first_name) }
  end

  context 'first_name should be correct length' do
    it { should validate_length_of(:first_name).is_at_least(2) }
    it { should validate_length_of(:first_name).is_at_most(140) }
  end

  context 'middle_name should be present' do
    it { should validate_presence_of(:middle_name) }
  end

  context 'middle_name should be correct length' do
    it { should validate_length_of(:middle_name).is_at_least(2) }
    it { should validate_length_of(:middle_name).is_at_most(140) }
  end

  context 'last_name should be present' do
    it { should validate_presence_of(:last_name) }
  end

  context 'last_name should be correct length' do
    it { should validate_length_of(:last_name).is_at_least(2) }
    it { should validate_length_of(:last_name).is_at_most(140) }
  end

  context 'status should be present' do
    it { should validate_presence_of(:status) }
  end

  context 'email should be present' do
    it { should validate_presence_of(:email) }
  end

  context 'phone should be present' do
    it { should validate_presence_of(:phone) }
  end

  context 'email should be uniqueness' do
    subject { build :employee }
    it { should validate_uniqueness_of(:email) }
  end


  context 'phone should be uniqueness' do
    #subject { create :employee }
    it { should validate_uniqueness_of(:phone).case_insensitive }
  end


  context 'salary should be valid' do
    it { should_not allow_value(-1).for(:salary) }
    it { should allow_value(0).for(:salary) }
  end


  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @employee.email = invalid_address
        expect(@employee).not_to be_valid
      end
    end
  end

  describe 'when email format is valid' do
     it 'should be valid' do
      addresses = %w[user@foo.com A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @employee.email=valid_address
        expect(@employee).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      @user_with_same_email = @employee.dup
      @user_with_same_email.email = @employee.email.upcase
      @user_with_same_email.save
    end
    it { expect(@user_with_same_email).not_to be_valid }
  end


  describe "when cyrillic" do
    context 'with correct first_name' do
      let(:first_name) { build :employee, :searched, :first_name }
      it { expect(first_name).to be_valid }
    end

    context 'with correct middle_name' do
      let(:middle_name) { build :employee, :searched, :middle_name }
      it { expect(middle_name).to be_valid }
    end

    context 'with correct last_name' do
      let(:last_name) { build :employee, :searched, :last_name }
      it { expect(last_name).to be_valid }
    end


    context 'with correct first_name and whitespaces' do
      let(:first_name) { build :employee, :searched, :first_name_w }
      it { expect(first_name).to be_valid }
    end

    context 'with correct middle_name and whitespaces' do
      let(:middle_name) { build :employee, :searched, :middle_name_w }
      it { expect(middle_name).to be_valid }
    end

    context 'with correct last_name and whitespaces' do
      let(:last_name) { build :employee, :searched, :last_name_w }
      it { expect(last_name).to be_valid }
    end

    context 'with wrong first_name' do
      let(:first_name) { build :employee, :searched, :wrong_first_name }
      it { expect(first_name).to be_invalid }
    end

    context 'with wrong middle_name' do
      let(:middle_name) { build :employee, :searched, :wrong_middle_name }
      it { expect(middle_name).to be_invalid }
    end

    context 'with wrong last_name' do
      let(:last_name) { build :employee, :searched, :wrong_last_name }
      it { expect(last_name).to be_invalid }
    end
  end


  describe 'scopes: ' do
    it 'salary asc order' do
      exp, exis = Employee.salary_ord.to_sql, Employee.order(salary: :asc).to_sql
      expect(exp).to eq exis
    end

    it 'all published employees' do
      exp, exis = Employee.to_show.to_sql, Employee.where(status: 0).to_sql
      expect(exp).to eq exis
    end

    context 'pagination' do
      it 'when page is 0' do
        exp = Employee.pagination(0).to_sql
        exis = Employee.offset(0).limit(5).to_sql
        expect(exp).to eq exis
      end

      it 'when page is 1' do
        exp = Employee.pagination(1).to_sql
        exis = Employee.offset(5).limit(5).to_sql
        expect(exp).to eq exis
      end
    end
  end


end
