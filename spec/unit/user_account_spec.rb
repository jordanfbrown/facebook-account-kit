module Facebook
  module AccountKit
    describe UserAccount do
      let(:subject) { described_class.new '12345' }

      context 'success' do
        it 'returns the user phone number' do
          expected_uri = URI('https://graph.accountkit.com/v1.0/me?access_token=12345&appsecret_proof=f33504f20f01865663144455838c35853730928cce84c16952da6a4e8ae3cde3')
          fake_body = { 'phone' => { 'number' => '+15559999' } }
          mocked_response = double('fake response',
                                   body: JSON.dump(fake_body),
                                   code: '200')

          expect(Net::HTTP).to receive(:get_response).with(expected_uri)
            .and_return(mocked_response)

          expect(subject.fetch_user_info).to eq fake_body
        end
      end

      context 'failure' do
        it 'raises a InvalidRequest when status is not a success' do
          error_message = { 'message' => 'You screwed up' }
          mocked_response = double('fake response',
                                   body: JSON.dump('error' => error_message),
                                   code: '400')

          expect(Net::HTTP).to receive(:get_response).and_return(mocked_response)

          expect do
            subject.fetch_user_info
          end.to raise_error(InvalidRequest, 'You screwed up')
        end
      end
    end
  end
end
