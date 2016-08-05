cask 'vlc' do
  version '2.2.4'
  sha256 'fd071b9817c9efccac5a144d69893a4a5323cbde4a74d5691c3cf3ab979d4160'

  url "https://get.videolan.org/vlc/#{version}/macosx/vlc-#{version}.dmg"
  appcast 'http://update.videolan.org/vlc/sparkle/vlc-intel64.xml',
          checkpoint: '0e71dfa9874979a8a9e6a9a3a7fdd21366a92082bce2836cbd938186ad5945fa'
  name 'VLC media player'
  homepage 'https://www.videolan.org/vlc/'
  license :oss
  gpg "#{url}.asc",
      key_id: '65f7c6b4206bd057a7eb73787180713be58d1adc'

  app 'VLC.app'
  # shim script (https://github.com/caskroom/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/vlcwrapper"
  binary shimscript, target: 'vlc'
  binary shimscript, target: 'cvlc'

  preflight do
    File.open(shimscript, 'w') do |f|
      f.puts '#!/bin/bash'
      f.puts 'interface=""'
      f.puts 'if [ $0 = "cvlc" ]; then'
      f.puts '  interface="--intf dummy"'
      f.puts 'fi'
      f.puts "#{appdir}/VLC.app/Contents/MacOS/VLC --color $interface \"$@\""
      FileUtils.chmod '+x', f
    end
  end

  zap delete: [
                '~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.videolan.vlc.sfl',
                '~/Library/Application Support/org.videolan.vlc',
                '~/Library/Preferences/org.videolan.vlc',
                '~/Library/Preferences/org.videolan.vlc.plist',
                '~/Library/Saved Application State/org.videolan.vlc.savedState',
              ]
end
