require 'rails_helper'

describe Api::V1::ReportsController do
  let!(:precinct) { Fabricate(:precinct) }

  describe '#show' do
    let!(:report) { Fabricate(:report) }

    subject { get :show, precinct_id: report.precinct_id, id: report.id }

    context 'user is admin' do
      before { login Fabricate(:admin) }

      it 'returns 200' do
        expect(subject).to have_http_status(200)
      end

      it 'returns the report' do
        expect(subject.body).to include_json(
          report: {
            id: report.id,
            precinct_id: report.precinct_id,
            source: report.source,
            phase: report.aasm_state
          }
        )
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe '#create' do
    let(:params) { {} }

    subject { post :create, precinct_id: precinct.id, report: params }

    context 'with invalid params' do
      let(:params) { { total_attendees: '' } }

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
    let!(:report) { Fabricate(:apportionment_report, total_attendees: 250, precinct: Fabricate(:precinct, total_delegates: 5)) }
    let(:params) { {} }

    subject { patch :update, precinct_id: report.precinct_id, id: report.id, report: params }

    context 'user is admin' do
      before { login Fabricate(:admin) }

      context 'with missing params' do
        it 'returns unprocessable' do
          expect(subject).to have_http_status(422)
        end
      end

      context 'with invalid params' do
        let(:params) { { total_attendees: '' } }

        it 'returns unprocessable' do
          expect(subject).to have_http_status(422)
        end
      end

      context 'with valid params' do
        context 'reverting to viability' do
          let(:params) { { phase: 'viability', total_attendees: 125 } }

          it 'updates the report' do
            expect(subject).to have_http_status(200)
            expect(report.reload.total_attendees).to eq(125)
          end

          it 'returns the report' do
            expect(subject.body).to include_json(
              report: {
                phase: 'viability',
                total_attendees: 125
              }
            )
          end
        end

        context 'setting delegate counts' do
          let(:params) { { delegate_counts: [{ key: 'sanders', supporters: 130 }] } }

          it 'updates the report' do
            expect(subject).to have_http_status(200)
            expect(report.reload.delegate_counts[:sanders]).to eq(130)
          end

          it 'returns the report' do
            expect(subject.body).to include_json(
              report: {
                phase: 'apportionment',
                delegate_counts: [{
                  key: 'sanders',
                  name: 'Bernie Sanders',
                  supporters: 130
                }]
              }
            )
          end
        end
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end

  describe '#destroy' do
    let!(:report) { Fabricate(:report) }

    subject { delete :destroy, precinct_id: report.precinct_id, id: report.id }

    context 'user is admin' do
      before { login Fabricate(:admin) }

      it 'returns 204' do
        expect(subject).to have_http_status(204)
      end

      it 'destroys the user' do
        expect { subject }.to change { Report.count }.by(-1)
      end
    end

    context 'user is captain' do
      before { login Fabricate(:captain) }

      it 'returns unauthorized' do
        expect(subject).to have_http_status(403)
      end
    end
  end
end
