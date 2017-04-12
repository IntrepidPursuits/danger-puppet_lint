require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerPuppetLint do
    it 'should be a plugin' do
      expect(Danger::DangerPuppetLint.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.puppet_lint
      end

      it 'Parses file with warnings and errors' do
        path = File.expand_path('../test_summary.report', __FILE__)
        @my_plugin.report(path)
        expect(@dangerfile.status_report[:errors].length).to be == 3
        expect(@dangerfile.status_report[:warnings].length).to be == 19
        expect(@dangerfile.status_report[:markdowns]).to eq([])
      end

      it 'Parses empty file' do
        path = File.expand_path('../test_empty_summary.report', __FILE__)
        @my_plugin.report(path)
        expect(@dangerfile.status_report[:errors]).to eq([])
        expect(@dangerfile.status_report[:warnings]).to eq([])
        expect(@dangerfile.status_report[:markdowns]).to eq([])
      end

    end
  end
end
