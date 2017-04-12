module Danger
  # Shows linter errors and warnings from puppet_lint
  # You'll need [puppet-lint](https://http://puppet-lint.com/) installed and
  # generating a report file to use this plugin
  #
  # @example Showing summary
  #
  #     puppet-lint ./ > puppet-lint.report
  #     danger-puppet_lint.report 'puppet-lint.report'
  #
  #
  # @see  IntrepidPursuits/danger-puppet_lint
  # @tags puppet, lint, configuration
  #
  class DangerPuppetLint < Plugin
    # The project root, which will be used to make the paths relative.
    # Defaults to `pwd`.
    # @return   [String] project_root value
    attr_accessor :project_root

    # Defines if the test summary will be sticky or not.
    # Defaults to `false`.
    # @return   [Boolean] sticky
    attr_accessor :sticky_summary

    def project_root
      root = @project_root || Dir.pwd
      root += '/' unless root.end_with? '/'
      root
    end

    def sticky_summary
      @sticky_summary || false
    end

    # Reads a puppet-lint summary file and reports it.
    #
    # @param    [String] file_path Path for puppet-lint report.
    # @return   [void]
    def report(file_path)
      raise 'Summary file not found' unless File.file?(file_path)
      run_summary(file_path)
    end

    private

    def run_summary(report_file)
      warning_count = 0
      error_count = 0

      # Read line-by-line to determine violations
      File.readlines(report_file).each do |line|
        if line.index('WARNING:').nil? == false
          warning_count += 1
          warn(format_violation(line), sticky: false)
        elsif line.index('ERROR:').nil? == false
          error_count += 1
          fail(format_violation(line), sticky: false)
        end
      end

      # Record the summary
      message(summary_message(warning_count, error_count), sticky: sticky_summary)
    end

    def summary_message(warning_count, error_count)
      violations = warning_count + error_count

      "Puppet-Lint Summary: Found #{violations} violations. #{warning_count}
      Warnings and #{error_count} Errors."
    end

    # A method that returns a formatted string for a violation
    # @return String
    #
    def format_violation(violation)
      violation.to_s
    end
  end
end
