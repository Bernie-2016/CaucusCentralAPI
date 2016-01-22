require 'rails_helper'

describe Api::V1::ReportsController do
  let!(:precinct) { Fabricate(:precinct) }

  describe '#create' do
    let(:params) { {} }

    subject { post :create, precinct_id: precinct.id, report: params }

    context 'with invalid params' do
      it 'returns unprocessable' do
        expect(subject).to have_http_status(422)
      end
    end

    context 'with valid params' do
      let(:params) { { phase: 'viability', total_attendees: 150 } }

      it 'creates the report' do
        expect(subject).to have_http_status(201)
      end

      it 'returns the report' do
        expect(subject.body).to include_json(
          report: {
            precinct_id: precinct.id,
            phase: 'viability',
            total_attendees: 150
          }
        )
      end
    end
  end

  describe '#update' do
  end
end
