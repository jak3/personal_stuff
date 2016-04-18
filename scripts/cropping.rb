#!/usr/bin/ruby
# -*- coding: utf-8 -*-

filenames = Dir.glob("*.mp3")

filenames.each do |filename|
      cmd = "soxi \"" + filename + "\" | grep Duration |  grep -o -E \"[0-9]{2}:[0-9]{2}\""
      times = `#{cmd}`.split(':')
      tenmin = times[1].to_i / 10
      min = times[1].to_i % 10
      nchunks = times[0].to_i * 6 + (min==0?tenmin:tenmin+1)
      # 600 = 10'
      (0..nchunks*10*60).step(600) { |x| `ffmpeg -ss #{x} -i #{filename} -c copy -t 600 #{filename[0..-5]}-#{x/10/60}.mp3`}
end
