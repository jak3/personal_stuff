#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# Get all mp3 in current directory
filenames = Dir.glob("*.mp3")

filenames.each do |filename|
  # get the duration in the format 'HH:MM', thanks soxi
  hhmm = "soxi '" + filename + "' | grep Duration |  grep -o -E \"[0-9]{2}:[0-9]{2}\""

  a_hhmm = `#{hhmm}`.split(':')
  # mm = m0 m1
  m0 = a_hhmm[1].to_i / 10
  m1 = a_hhmm[1].to_i % 10

  # UNIT is seconds, according to ffmpeg
  chunk_size = 10*60 # 600 seconds = 10 minutes
  nchunks = a_hhmm[0].to_i * 6 + (m1 == 0 ? m0 : m0+1)
  (0..nchunks*chunk_size).step(chunk_size) { |x|
    `ffmpeg -ss #{x} -i '#{filename}' -c copy -t #{chunk_size} '#{filename[0..-5]}-#{x/chunk_size}.mp3'`
  }

end
