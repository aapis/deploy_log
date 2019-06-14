# frozen_string_literal: true

require 'fileutils'

module DeployLog
  class Cache
    attr_reader :filename

    class FileNotFound < StandardError; end

    def initialize(fmt, options = {})
      fmt ||= 'deploy_%s.log'
      dir = options[:dir] || '/tmp'

      @repo = options[:repo]
      @file_name_template = "#{dir}/#{fmt}"
    end

    def create(*args)
      hash = Digest::MD5.hexdigest(@repo + args.join('|'))
      path = FileUtils.touch format(@file_name_template, hash)

      @filename = path.first
    end

    def exists?
      File.exist?(@filename) && !File.size(@filename).zero?
    end

    def contents
      raise FileNotFound unless exists?

      File.read(@filename)
    end

    def write_object(pool, message)
      File.open(@filename, 'w+') do |file|
        pool.each do |pr|
          line = yield(pr)

          file.write(line)
        end

        file.write "============================================================\n"
        file.write "#{message}\n"
        file.write "============================================================\n"
      end
    end
  end
end
