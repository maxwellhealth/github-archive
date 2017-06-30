module GithubArchive
  class Util
    # turn a folder into a tarball
    class Tar
      require 'rubygems/package'

      attr_accessor :path
      attr_reader :size

      def initialize
        @path = ''
        @size = 0
      end

      def tar(source, target)
        File.open(target, 'wb') do |tarfile|
          relative_regexp = %r{^#{Regexp.escape(source)}\/?}
          Gem::Package::TarWriter.new(tarfile) do |tar|
            Dir[File.join(source, '**/*')].each do |file|
              stat = File.lstat(file)
              relative_file = file.sub(relative_regexp, '')
              next unless stat.ftype == 'file'
              tar.add_file relative_file, stat.mode do |tf|
                File.open(file, 'rb') do |f|
                  while buffer = f.read(1024 * 1000)
                    tf.write buffer
                  end
                end
              end
            end
          end
          @size = tarfile.size
        end
      end
    end
  end
end
