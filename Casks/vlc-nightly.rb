cask 'vlc-nightly' do
  version :latest
  sha256 :no_check

  url 'http://nightlies.videolan.org/build/macosx-intel/last'
  name 'VLC media player'
  homepage 'https://www.videolan.org/vlc/'
  license :oss

  depends_on macos: '>= :lion'

  app 'VLC.app', target: 'VLC (Nightly).app'

   # shim script (https://github.com/caskroom/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/vlcwrapper"
  binary shimscript, target: 'nvlc'

  preflight do
    File.open(shimscript, 'w') do |f|
      f.puts '#!/bin/bash'
      f.puts "#{appdir}/VLC\\ \\(Nightly\\).app/Contents/MacOS/VLC --color --intf dummy \"$@\""
      FileUtils.chmod '+x', f
    end
  end
end
