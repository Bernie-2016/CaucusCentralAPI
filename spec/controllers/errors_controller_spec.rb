require 'rails_helper'

describe ErrorsController do
  describe '#error_404' do
    subject { get :error_404 }

    it 'returns 404' do
      expect(subject).to have_http_status(404)
    end
  end

  describe '#error_422' do
    subject { get :error_422 }

    it 'returns 422' do
      expect(subject).to have_http_status(422)
    end
  end

  describe '#error_500' do
    subject { get :error_500 }

    it 'returns 500' do
      expect(subject).to have_http_status(500)
    end
  end
end
