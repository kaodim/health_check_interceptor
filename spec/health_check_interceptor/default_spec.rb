RSpec.describe HealthCheckInterceptor::Default do
  describe 'default configuration' do
    subject { described_class.configuration }
    it 'should have default configuration' do
      expect(subject.url_pattern).to eq %r{(\/|\/are_you_alive)$}
      expect(subject.response_code).to eq 200
      expect(subject.headers).to eq({})
      expect(subject.body).to eq [{ message: 'I am alive.' }.to_json]
    end
  end

  describe '.configure' do
    subject { described_class.configuration }
    it 'should change the configuration' do
      described_class.configure do |config|
        config.url_pattern = /foo/
        config.response_code = 201
        config.headers = { "foo" => "bar" }
        config.body = ["I am alive."]
      end

      expect(subject.url_pattern).to eq /foo/
      expect(subject.response_code).to eq 201
      expect(subject.headers).to eq({ "foo" => "bar" })
      expect(subject.body).to eq ['I am alive.']
    end
  end

  describe 'intercept' do
    let(:interceptor) { described_class.new(-> (env) { 'Skip interception' }) }
    let(:env) { {"REQUEST_URI" => 'http://localhost:3000/foo'} }

    before do
      described_class.configure do |config|
        config.url_pattern = /foo/
        config.response_code = 201
        config.headers = { "foo" => "bar" }
        config.body = ["I am alive."]
      end
    end

    subject { interceptor.call(env) }

    context 'when uri match interception pattern'
    it 'should response with interception message' do
      expect(subject).to eq [201, {"foo" => "bar"}, ["I am alive."]]
    end

    context 'when uri does not match interception pattern' do
      let(:env) { {"REQUEST_URI" => 'http://localhost:3000/bar'} }
      it 'should skip interception' do
        expect(subject).to eq "Skip interception"
      end
    end
  end
end
