require 'spec_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should allow_value("email@addresse.foo").for(:email) }
  it { should_not allow_value("foo").for(:email) }
  it { should allow_value("(21) 99999999").for(:phone) }
  it { should allow_value("(21) 999999999").for(:phone) }
  it { should_not allow_value("(21) 9999999").for(:phone) }

  it { should have_many :memberships }
  it { should have_many :organizations }

  describe "#availability" do
    before do
      subject.availability << :remote_monday_night
      subject.availability.delete(:local_friday_morning)
      subject.save
    end

    it 'has availability' do
      subject.availability?.should be_true
    end

    it 'has remote availability on Monday night' do
      subject.availability?(:remote_monday_night).should be_true
    end

    it 'has not local availability on Friday morning' do
      subject.availability?(:local_friday_morning).should be_false
    end
  end

  describe "#skills" do
    before do
      subject.skills = ['administracao_e_politicas_publicas']
      subject.save
    end

    it 'has skills' do
      subject.skills.any?.should be_true
    end

    it 'has skill in Administracao e Politicas Publicas' do
      subject.skills.include?('administracao_e_politicas_publicas').should be_true
    end

    it 'has not skill in Jornalismo Assessoria de Imprensa' do
      subject.skills.include?('jornalismo_assessoria_de_imprensa').should be_false
    end
  end

  describe "#fetch_address" do
    context "when the postcode is valid" do
      before do
        stub_request(:get, "http://brazilapi.herokuapp.com/api?cep=").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '[{"cep":{"valid":true,"result":true,"data":{"id":"19451","cidade":"Rio de Janeiro","logradouro":"Dona Mariana","bairro":"Botafogo","cep":"22280-020","tp_logradouro":"Rua","cidade_sem_acento":"rio de janeiro","cidade_ibge":"3304557","uf":"rj"},"message":""}}]', :headers => {})
      end

      it "should update user attributes" do
        subject.should_receive(:update_columns).with({city: "Rio de Janeiro", address_street: "Rua Dona Mariana", address_district: "Botafogo", state: "rj"})
        subject.fetch_address
      end
    end

    context "when the postcode is invalid" do
      before do
        stub_request(:get, "http://brazilapi.herokuapp.com/api?cep=").
          with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => '[{"cep":{"valid":false}}]', :headers => {})
      end

      it "should not update user attributes" do
        subject.should_not_receive(:update_columns)
        subject.fetch_address
      end
    end
  end
end
