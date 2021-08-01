require 'rails_helper'

RSpec.describe Users::ResetProgress do
  let(:user) { create(:user) }
  let!(:foundations_path) { create(:path, default_path: true) }
  let!(:foundations_course) { create(:course, path: foundations_path) }
  let!(:foundations_section) { create(:section, course: foundations_course) }
  let!(:foundations_lesson_one) { create(:lesson, section: foundations_section) }
  let!(:foundations_lesson_two) { create(:lesson, section: foundations_section) }
  let!(:foundations_lesson_one_completion) { create(:lesson_completion, lesson: foundations_lesson_one, user: user) }
  let!(:foundations_lesson_two_completion) { create(:lesson_completion, lesson: foundations_lesson_two, user: user) }
  subject(:service) { described_class.call(user) }

  describe '#call' do
    context 'when path is default path' do
      it 'deletes all lesson completions' do
        expect { service }.to change { user.lesson_completions.count }.from(2).to(0)
      end

      it 'does not change path' do
        expect { service }.not_to(change { user.path })
      end
    end

    context 'when path is not the default path' do
      let!(:rails_path) { create(:path) }
      let!(:rails_course) { create(:course, path: rails_path) }
      let!(:rails_section) { create(:section, course: rails_course) }
      let!(:rails_lesson) { create(:lesson, section: rails_section) }
      let!(:rails_lesson_completion) { create(:lesson_completion, lesson: rails_lesson, user: user) }

      before do
        user.update(path: rails_path)
      end

      it 'deletes all lesson completions' do
        expect { service }.to change { user.lesson_completions.count }.from(3).to(0)
      end

      it 'changes path to the default path' do
        expect { service }.to change { user.path.default_path }.from(false).to(true)
      end
    end
  end

  describe '#success?' do
    it 'returns true' do
      expect(service.success?).to be(true)
    end
  end
end
